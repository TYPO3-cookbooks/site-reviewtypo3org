remote_file "#{node['gerrit']['install_dir']}/plugins/rabbitmq.jar" do
  source "http://st-g.de/fileadmin/downloads/2015-10/rabbitmq-1.5-SNAPSHOT-20150203154700.jar"
  # this should be the following URL, but somehow this doesn't work today (see http://stackoverflow.com/questions/33223904/chef-remote-file-download-from-github-fails)
  # source "https://github.com/TYPO3-infrastructure/gerrit-rabbitmq-plugin/releases/download/rabbitmq-1.5-SNAPSHOT-20150203154700/rabbitmq-1.5-SNAPSHOT-20150203154700.jar"
  owner node['gerrit']['user']
  group node['gerrit']['group']
end

# read AMQP password from chef-vault
include_recipe "t3-chef-vault"
amqp_pass = chef_vault_password(node['site-reviewtypo3org']['amqp']['server'], node['site-reviewtypo3org']['amqp']['user'])


template "#{node['gerrit']['install_dir']}/etc/rabbitmq.config" do
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