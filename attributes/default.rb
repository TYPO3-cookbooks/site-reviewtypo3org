default['git']['hostname'] = "dev.git.typo3.org"
default['git']['hostname'] = "git.typo3.org" if node.chef_environment == "production"


default['gerrit']['config']['database']['type'] = "mysql"
default['gerrit']['config']['auth']['type'] = "HTTP"
default['gerrit']['config']['auth']['cookieSecure'] = true
default['gerrit']['config']['auth']['gitBasicAuth'] = true
default['gerrit']['proxy']['ssl']['enable'] = true


# AMPQ worker
default['site-reviewtypo3org']['amqp']['server'] = nil
default['site-reviewtypo3org']['amqp']['user'] = nil
default['site-reviewtypo3org']['amqp']['vhost'] = nil
default['site-reviewtypo3org']['mq-worker']['gerrit']['user'] = 'gerrit-mq-worker'


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
