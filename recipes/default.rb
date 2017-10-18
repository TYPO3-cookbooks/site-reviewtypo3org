#
# Cookbook Name:: site-reviewtypo3org
# Recipe:: default
#
# Copyright (C) Steffen Gebert / TYPO3 Association
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "t3-base"

## Otherwise the chef_gem[mysql] fails to install
build_essential 'install_packages' do
  compile_time true
end
include_recipe "t3-mysql::server"
include_recipe "t3-mysql::backup"

include_recipe 'gerrit::default'

include_recipe "#{cookbook_name}::to-refactor"

include_recipe "site-gittypo3org"
# this has to run after inclusion of site-gittypo3org
# include_recipe "t3-gerrit::replication"
