#
# Cookbook Name:: typo3
# Recipe:: default
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

include_recipe 'apt::default'
include_recipe 'apt::unattended-upgrades'
include_recipe 'build-essential::default'
include_recipe 'timezone-ii::default'
include_recipe 'hostnames::default'

include_recipe 'locales'
include_recipe 'typo3::system'
include_recipe 'typo3::mysql'
include_recipe 'typo3::phpmyadmin'
include_recipe 'typo3::nodejs'
include_recipe 'typo3::memcached'
include_recipe 'typo3::php'
include_recipe 'typo3::composer'
include_recipe 'typo3::nginx'
include_recipe 'typo3::tools'
