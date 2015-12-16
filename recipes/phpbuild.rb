#
# Cookbook Name:: typo3
# Recipe:: phpbuild
#
# Copyright (C) 2015 Morton Jonuschat <m.jonuschat@mojocode.de>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

node['phpbuild']['packages'].each do |pkg|
  package pkg do
    action :upgrade
  end
end

git node['phpbuild']['installdir'] do
  repository node['phpbuild']['repository']
  revision   node['phpbuild']['revision']
  action     :sync
end

node['phpbuild']['versions'].each do |family, configuration|
  execute "phpbuild #{family}" do
    command     "bin/php-build #{configuration[:version]} #{node['phpbuild']['installdir_php']}/#{configuration[:version]}"
    cwd         node['phpbuild']['installdir']
    environment 'PHP_BUILD_CONFIGURE_OPTS'        => configuration[:options],
                'PHP_BUILD_INSTALL_EXTENSION'     => configuration[:extensions],
                'PHP_BUILD_EXTRA_MAKE_ARGUMENTS'  => "-j #{node['cpu']['total'] || 2}"
    creates     "#{node['phpbuild']['installdir_php']}/#{configuration[:version]}/bin/php"
  end

  directory "/opt/php/#{configuration[:version]}/etc/php-fpm.d" do
    action :create
    mode '0755'
  end

  template "/opt/php/#{configuration[:version]}/etc/php-fpm.conf" do
    source      'php/php-fpm.conf.erb'
    variables   options: {
                  'pool_conf_dir' => "#{node['phpbuild']['installdir_php']}/#{configuration[:version]}/etc/php-fpm.d",
                  'error_log'     => "/var/log/php#{family}-fpm.log",
                  'pid_file'      => "/run/php#{family}-fpm.pid",

                }
    mode        '0644'
    notifies    :restart, "systemd_service[php#{family}-fpm]"
  end

  link "/opt/php/#{family}" do
    to "/opt/php/#{configuration[:version]}"
    link_type :symbolic
  end

  if configuration[:default]
    template    '/etc/profile.d/php.sh' do
      source    'php/path.sh'
      variables default_php_path: "/opt/php/#{configuration[:version]}/bin"
      owner     'root'
      group     'root'
      mode      '0644'
    end
  end

  node['php-fpm']['pools'].each do |pool_name, params|
    template "/opt/php/#{configuration[:version]}/etc/php-fpm.d/#{pool_name}.conf" do
      source 'php/php-pool.conf.erb'
      owner "root"
      group "root"
      mode '0644'
      variables(
        php_family: family,
        pool_name: pool_name,
        listen: params[:listen],
        listen_owner: params[:listen_owner] || node['php-fpm']['listen_owner'] || node['php-fpm']['user'],
        listen_group: params[:listen_group] || node['php-fpm']['listen_group'] || node['php-fpm']['group'],
        listen_mode: params[:listen_mode] || node['php-fpm']['listen_mode'] || '0600',
        allowed_clients: params[:allowed_clients],
        user: params[:user],
        group: params[:group],
        process_manager: params[:process_manager],
        max_children: params[:max_children],
        start_servers: params[:start_servers],
        min_spare_servers: params[:min_spare_servers],
        max_spare_servers: params[:max_spare_servers],
        max_requests: params[:max_requests],
        catch_workers_output: params[:catch_workers_output],
        security_limit_extensions: params[:security_limit_extensions] || node['php-fpm']['security_limit_extensions'],
        access_log: params[:access_log] || false,
        php_options: params[:php_options] || {},
        request_terminate_timeout: params[:request_terminate_timeout],
        params: params
      )
      notifies :restart, "systemd_service[php#{family}-fpm]"
    end
  end

  systemd_service "php#{family}-fpm" do
    description "The PHP #{family} FastCGI Process Manager"
    after %w( network.target )
    install do
      wanted_by 'multi-user.target'
    end

    service do
      exec_start  "/opt/php/#{configuration[:version]}/sbin/php-fpm --nodaemonize --fpm-config /opt/php/#{configuration[:version]}/etc/php-fpm.conf"
      exec_reload '/bin/kill -USR2 $MAINPID'
      type        'simple'
      pid_file    "/run/php#{family}-fpm.pid"
    end
    action [:create, :enable, :start]
  end
end
