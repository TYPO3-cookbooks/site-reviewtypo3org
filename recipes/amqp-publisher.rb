remote_file "#{node['gerrit']['install_dir']}/plugins/rabbitmq.jar" do
  source "https://github.com/rinrinne/gerrit-rabbitmq-plugin/releases/download/rabbitmq-1.4/rabbitmq-1.4-2.8.5.jar"
  owner node['gerrit']['user']
  group node['gerrit']['group']
end

template "#{node['gerrit']['install_dir']}/etc/rabbitmq.config" do
  source "amqp-publisher/rabbitmq.config.erb"
  owner node['gerrit']['user']
  group node['gerrit']['group']
  variables(
    :amqp => {
      :uri => "amqp://mq.typo3.org/test",
      :username => "test",
      :password => "test"
    }
  )
end