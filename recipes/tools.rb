#
# Cookbook Name:: typo3
# Recipe:: tools
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

package 'parallel' do
  action :upgrade
end

node['nginx']['sites'].each do |server_name, configuration|
  next unless configuration['default']

  template "/usr/local/bin/t3u" do
    source "typo3/t3u.sh.erb"
    owner "root"
    group "root"
    mode "0755"
    variables 'php_version' => configuration['default_php_version'],
              'site' => server_name
  end

  template "/usr/local/bin/t3f" do
    source "typo3/t3f.sh.erb"
    owner "root"
    group "root"
    mode "0755"
    variables 'php_version' => configuration['default_php_version'],
              'site' => server_name
  end
end
