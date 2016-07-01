#
# Cookbook Name:: typo3
# Recipe:: php
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

apt_repository 'php' do
  uri "http://ppa.launchpad.net/ondrej/php/#{node['platform']}"
  distribution node['lsb']['codename']
  components ['main']
  key 'ppa.ondrej.php.gpg'
end

node['php']['versions'].each do |version|
  packages = node['php']['extensions'].map { |ext| "php#{version}-#{ext}"}
  packages << "php#{version}"
  package packages do
    action :upgrade
  end

  service "php#{version}-fpm" do
    action [:enable, :start]
  end

  template "/etc/php/#{version}/fpm/php-fpm.conf" do
    source      'php/php-fpm.conf.erb'
    variables   options: {
        'pool_conf_dir' => "/etc/php/#{version}/fpm/pool.d",
        'error_log'     => "/var/log/php#{version}-fpm.log",
        'pid_file'      => "/run/php/php#{version}-fpm.pid",

    }
    mode        '0644'
    notifies    :restart, "service[php#{version}-fpm]"
  end

  node['php-fpm']['pools'].each do |pool_name, params|
    template "/etc/php/#{version}/fpm/pool.d/#{pool_name}.conf" do
      source 'php/php-pool.conf.erb'
      owner "root"
      group "root"
      mode '0644'
      variables(
          php_family: version,
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
          access_log: params[:access_log],
          php_options: params[:php_options] || {},
          request_terminate_timeout: params[:request_terminate_timeout],
          params: params
      )
      notifies :restart, "service[php#{version}-fpm]"
    end
  end
end

execute 'enable xdebug in php-fpm' do
  command '/usr/sbin/phpenmod -v ALL -s fpm xdebug'
end

execute 'disable xdebug in php-cli' do
  command '/usr/sbin/phpdismod -v ALL -s cli xdebug'
end

execute 'set default php version' do
  command 'update-alternatives --set php /usr/bin/php7.0'
end
