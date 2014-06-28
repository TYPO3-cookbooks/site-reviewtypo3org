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

deploy_base = "/srv/mq-worker-reviewtypo3org"

package "ruby"
package "bundler"

gerrit_ssh_port = '29418'

# create shared config directory
[deploy_base, "#{deploy_base}/shared", "#{deploy_base}/shared/config"].each do |dir|
  directory dir do
    owner "gerrit"
    group "gerrit"
    recursive true
    action :create
  end
end

# handle amqp password
if Chef::Config[:solo]
  Chef::Log.warn "AMQP connection will be disabled as running inside of chef-solo!"
  amqp_pass = "fooo"
else
  Chef::Log.info "AMQP credentials: #{node['site-reviewtypo3org']['amqp']['user']}@#{node['site-reviewtypo3org']['amqp']['server']}"

  # read AMQP password from chef-vault
  include_recipe "chef-vault"
  amqp_pass = chef_vault_password(node['site-reviewtypo3org']['amqp']['server'], node['site-reviewtypo3org']['amqp']['user'])

end


# create a proper amqp.yml
template "#{deploy_base}/shared/config/amqp.yml" do
  owner      "gerrit"
  group      "gerrit"
  source     "worker/amqp.yml.erb"
  variables({
    :data => {
      :user => node['site-reviewtypo3org']['amqp']['user'],
      :pass => amqp_pass,
      :host => node['site-reviewtypo3org']['amqp']['server'],
      :vhost => node['site-reviewtypo3org']['amqp']['vhost']
    }
  })
end

# create ssh key for mq-worker to connect to gerrit
ssh_key_filename = "id_rsa-#{node['site-reviewtypo3org']['mq-worker']['gerrit']['user']}"
ssh_key = node['gerrit']['home'] + "/.ssh/" + ssh_key_filename
execute "generate private ssh key for 'Gerrit Code Review' user" do
  command "ssh-keygen -t rsa -q -f #{ssh_key} -C\"#{node['site-reviewtypo3org']['mq-worker']['gerrit']['user']}@#{node['gerrit']['hostname']}\""
  user "gerrit"
  creates ssh_key
  #not_if { File.exists?ssh_key }
end

# check wether mq-worker can connect to gerrit
execute "add mq user to gerrit" do
  admin_user = node['gerrit']['batch_admin_user']['username']
  admin_key_file = node['gerrit']['home'] + "/.ssh/id_rsa-#{admin_user}.pub"
  command "ssh -i #{admin_key_file} -o StrictHostKeyChecking=no -p 29418 \"#{admin_user}@#{node['gerrit']['hostname']}\" gerrit help"
  #Chef::Application.fatal!("Please manually create user first") if Gerrit::Helpers.ssh_can_connect?(node['site-reviewtypo3org']['mq-worker']['gerrit']['user'], "#{ssh_key}.pub", node['gerrit']['hostname'], 29418)
end

# create a proper gerrit.yml for the worker
template "#{deploy_base}/shared/config/gerrit.yml" do
  owner      "gerrit"
  group      "gerrit"
  source     "worker/gerrit.yml.erb"
  variables({
    :data => {
      :user => node['site-reviewtypo3org']['mq-worker']['gerrit']['user'],
      :host => node['gerrit']['hostname'],
      :port => gerrit_ssh_port,
    }
  })
end


# deploy resource for mq-worker-gerrittypo3org
deploy_revision "mq-worker-reviewtypo3org" do
  #action  :force_deploy
  deploy_to      deploy_base
  repository     "https://github.com/TYPO3-infrastructure/mq-worker-reviewtypo3org"
  migrate        false
  user           "gerrit"
  group          "gerrit"
  symlink_before_migrate ({
    'config/amqp.yml' => 'config/amqp.yml',
    'config/gerrit.yml' => 'config/gerrit.yml'
  })
  before_symlink do

    directory "#{deploy_base}/shared/log" do
      owner "gerrit"
      group "gerrit"
    end

    execute "bundle install --path=vendor/bundle --without development test" do
      cwd release_path
      user           "gerrit"
    end

  end
  notifies :restart, "runit_service[mq-worker-reviewtypo3org]"
end


include_recipe "runit"

runit_service "mq-worker-reviewtypo3org" do
  owner          "gerrit"
  group          "gerrit"
  default_logger true
  options ({
    :deploy_base => deploy_base}.merge(params)
  )
end
