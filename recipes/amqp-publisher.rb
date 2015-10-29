remote_file "#{node['gerrit']['install_dir']}/plugins/rabbitmq.jar" do
  source "https://gerrit-ci.gerritforge.com/job/plugin-rabbitmq-stable-2.11/lastSuccessfulBuild/artifact/buck-out/gen/plugins/rabbitmq/rabbitmq.jar"
  owner node['gerrit']['user']
  group node['gerrit']['group']
end

# read AMQP password from chef-vault
include_recipe "t3-chef-vault"
amqp_pass = chef_vault_password(node['site-reviewtypo3org']['amqp']['server'], node['site-reviewtypo3org']['amqp']['user'])

directory "#{node['gerrit']['install_dir']}/data/rabbitmq" do
  owner node['gerrit']['user']
  group node['gerrit']['group']
end

template "#{node['gerrit']['install_dir']}/data/rabbitmq/rabbitmq.config" do
  source "amqp-publisher/rabbitmq.config.erb"
  owner node['gerrit']['user']
  group node['gerrit']['group']
  variables(
    :amqp => {
      :uri => "amqp://#{node['site-reviewtypo3org']['amqp']['server']}/#{node['site-reviewtypo3org']['amqp']['vhost']}",
      :username => node['site-reviewtypo3org']['amqp']['user'],
      :password => amqp_pass
    }
  )
  notifies :restart, "service[gerrit]"
end