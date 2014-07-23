default['gerrit']['version'] = "2.9"
override['gerrit']['war']['download_url'] = "http://gerrit-releases.storage.googleapis.com/gerrit-2.9.war"

default['git']['hostname'] = "dev.git.typo3.org"
default['git']['hostname'] = "git.typo3.org" if node.chef_environment == "production"

default['gerrit']['config']['database']['type'] = "MYSQL"
default['gerrit']['config']['database']['database'] = "gerrit"
default['gerrit']['config']['auth']['type'] = "HTTP"
default['gerrit']['config']['auth']['cookieSecure'] = true
default['gerrit']['config']['auth']['gitBasicAuth'] = true
default['gerrit']['proxy']['ssl'] = true

default['gerrit']['batch_admin_user']['enabled'] = true
