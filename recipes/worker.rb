#
# Cookbook Name:: site-reviewtypo3org
# Recipe:: worker
#
# Copyright 2013, TYPO3 Association
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

deploy_base = "/srv/mq-worker"

package "ruby"
package "bundler"

deploy_revision "mq-worker" do
  deploy_to      deploy_base
  repository     "https://github.com/TYPO3-infrastructure/mq-worker-reviewtypo3org"
  migrate        false
  user           "gerrit"
  group          "gerrit"
  before_symlink do

    template "#{release_path}/config/amqp.yml" do
      owner      "gerrit"
      group      "gerrit"
      variables({
      :data => {
      :user => '',
      :pass => '',
      :host => '',
      :vhost => '',
      }
      })
    end

    execute "bundle install" do
      cwd release_path
      user           "gerrit"
    end

  end
  notifies :restart, "runit_service[mq-worker-git-create]"
end


include_recipe "runit"

runit_service "mq-worker-git-create" do
  default_logger true
  owner          "gerrit"
  group          "gerrit"
end
