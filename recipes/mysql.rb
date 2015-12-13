#
# Cookbook Name:: typo3
# Recipe:: mysql
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
apt_repository 'repo.mysql.com' do
  uri "http://repo.mysql.com/apt/#{node['platform']}"
  distribution node['lsb']['codename']
  components ["mysql-#{node['mysql']['version']}"]
  key 'repo.mysql.com.gpg'
end

mysql2_chef_gem 'default' do
  action :install
end

mysql_service 'typo3' do
  initial_root_password node['mysql']['initial_root_password']
  bind_address '0.0.0.0'
  port '3306'
  charset 'utf8'
  action [:create, :start]
  package_name "mysql-server-#{version node['mysql']['version']}"
end

mysql_config 'typo3' do
  source 'utf8.cnf.erb'
  notifies :restart, 'mysql_service[typo3]'
  action :create
end

mysql_client 'default' do
  action :create
end

mysql_connection_info = {
  host:     '127.0.0.1',
  username: 'root',
  password: node['mysql']['initial_root_password']
}

mysql_database 'test' do
  connection mysql_connection_info
  action    :drop
end

mysql_database 'typo3_master' do
  connection mysql_connection_info
  action :create
end

mysql_database_user 'typo3' do
  connection mysql_connection_info
  password 'typo3'
  action :create
end

mysql_database_user 'typo3' do
  connection mysql_connection_info
  database_name 'typo3_master'
  privileges [:all]
  action :grant
end

template "/root/.my.cnf" do
  owner "root"
  group "root"
  mode "0600"
  source "my.cnf.erb"
end

template "/home/vagrant/.my.cnf" do
  owner "vagrant"
  group "vagrant"
  mode "0600"
  source "my.cnf.erb"
end