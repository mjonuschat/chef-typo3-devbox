#
# Cookbook Name:: typo3
# Recipe:: nginx
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

package %w(nginx nginx-full) do
  action :upgrade
end

# Remove default site
file '/etc/nginx/sites-enabled/default' do
  action :delete
end

# PHP-FPM Upstreams
node['php']['versions'].each do |version|
  template "/etc/nginx/conf.d/upstream-php-#{version}.conf" do
    source 'nginx/upstream.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables 'upstream_name' => "php-#{version}"
    notifies :restart, 'service[nginx]'
  end
end

# Default Server
template '/etc/nginx/sites-enabled/local.typo3.org.conf' do
  source 'nginx/site.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables 'configuration' => {
                'default_php_version' => '5.6',
                'document_root' => node['phpmyadmin']['home'],
            },
            'server_name' => 'local.typo3.org',
            'listen_options' => 'default_server'
  notifies :restart, 'service[nginx]'
end

# TYPO3 Sites
node['nginx']['sites'].each do |server_name, configuration|
  template "/etc/nginx/sites-enabled/#{server_name}.conf" do
    source 'nginx/site.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables 'configuration' => configuration,
              'server_name' => server_name
    notifies :restart, 'service[nginx]'
  end
end

service 'nginx' do
  action [:enable, :start]
end
