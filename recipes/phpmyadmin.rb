#
# Cookbook Name:: typo3
# Recipe:: phpmyadmin
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

directory node['phpmyadmin']['home'] do
  action :delete
  recursive true
  not_if { ::File.exists?("#{node['phpmyadmin']['home']}/RELEASE-DATE-#{node['phpmyadmin']['version']}")}
end

directory node['phpmyadmin']['home'] do
  action :create
  owner node['phpmyadmin']['user']
  group node['phpmyadmin']['user']
  mode '0755'
  not_if { ::File.exists?("#{node['phpmyadmin']['home']}/RELEASE-DATE-#{node['phpmyadmin']['version']}")}
end

tar_extract "#{node['phpmyadmin']['mirror']}/#{node['phpmyadmin']['version']}/phpMyAdmin-#{node['phpmyadmin']['version']}-all-languages.tar.gz" do
  target_dir node['phpmyadmin']['home']
  creates "#{node['phpmyadmin']['home']}/RELEASE-DATE-#{node['phpmyadmin']['version']}"
  tar_flags [ '--strip-components 1' ]
  checksum node['phpmyadmin']['checksum']
end

directory "#{node['phpmyadmin']['home']}/conf.d" do
  owner node['phpmyadmin']['user']
  group node['phpmyadmin']['group']
  mode '0755'
  recursive true
  action :create
end

template "#{node['phpmyadmin']['home']}/config.inc.php" do
  source 'phpmyadmin/config.inc.php.erb'
  owner node['phpmyadmin']['user']
  group node['phpmyadmin']['group']
  mode '0640'
end

template "#{node['phpmyadmin']['home']}/conf.d/typo3.inc.php" do
  source 'phpmyadmin/instance.inc.php.erb'
  owner node['phpmyadmin']['user']
  group node['phpmyadmin']['group']
  mode '0640'
  variables :name => 'local.typo3.org',
            :host => '127.0.0.1',
            :port => '3306',
            :user => 'root',
            :pass => node['mysql']['initial_root_password'],
            :pma_user => node['phpmyadmin']['pma_user'],
            :pma_pass => node['phpmyadmin']['pma_pass'],
            :pma_db => 'phpmyadmin',
            :auth_type => 'cookie'
end

mysql_connection_info = {
  host:     '127.0.0.1',
  username: 'root',
  password: node['mysql']['initial_root_password']
}

mysql_database 'phpmyadmin' do
  connection mysql_connection_info
  action :create
  notifies :run, 'execute[import phpmyadmin tables]'
end

mysql_database_user node['phpmyadmin']['pma_user'] do
  connection mysql_connection_info
  password node['phpmyadmin']['pma_pass']
  action :create
end

mysql_database_user node['phpmyadmin']['pma_user'] do
  connection mysql_connection_info
  database_name 'phpmyadmin'
  privileges [:all]
  action :grant
end

execute 'import phpmyadmin tables' do
  command "/usr/bin/mysql -uroot -p#{node['mysql']['initial_root_password']} -h127.0.0.1 < #{node['phpmyadmin']['home']}/sql/create_tables.sql"
  sensitive true
  action :nothing
end
