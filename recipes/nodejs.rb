#
# Cookbook Name:: typo3
# Recipe:: nodejs
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

remote_file "#{Chef::Config['file_cache_path']}/nodejs-v#{node['nodejs']['version']}.tar.gz" do
  source "https://nodejs.org/dist/v#{node['nodejs']['version']}/node-v#{node['nodejs']['version']}-linux-x64.tar.gz"
  owner 'root'
  group 'root'
  mode '0644'
  checksum node['nodejs']['checksum']
  notifies :run, 'bash[install nodejs]'
end

bash 'install nodejs' do
  code <<-EOH
  cd /usr/local
  tar --strip-components 1 -xzf #{Chef::Config['file_cache_path']}/nodejs-v#{node['nodejs']['version']}.tar.gz
  chown -R vagrant:vagrant /usr/local/lib/node_modules
  EOH
  action :nothing
end
