# AMPQ worker listening to the MQ server

default['site-reviewtypo3org']['amqp']['server'] = nil
default['site-reviewtypo3org']['amqp']['user'] = nil
default['site-reviewtypo3org']['amqp']['vhost'] = nil
default['site-reviewtypo3org']['mq-worker']['gerrit']['user'] = 'gerrit-mq-worker'
default['site-reviewtypo3org']['mq-worker']['gerrit']['user_name'] = 'Gerrit MQ Worker'
default['site-reviewtypo3org']['mq-worker']['gerrit']['user_email'] = 'admin+gerrit-mq-worker@typo3.org'


# override defaults for production
if node.chef_environment == 'production'
  default['site-reviewtypo3org']['amqp'] = {
    'server' => 'mq.typo3.org',
    'user' => 'reviewtypo3org',
    'vhost' => 'infrastructure'
  }
# override defaults for pre-production
elsif node.chef_environment == 'pre-production'
  default['site-reviewtypo3org']['amqp'] = {
    'server' => 'mq.typo3.org',
    'user' => 'devreviewtypo3org',
    'vhost' => 'infrastructure_dev'
  }
end
