default['gerrit']['version'] = "2.12.6"

default['gerrit']['hostname'] = "review.typo3.org"

default['gerrit']['config']['gerrit']['canonicalWebUrl'] = "https://#{node['gerrit']['hostname']}/"
default['gerrit']['config']['gerrit']['canonicalGitUrl'] = "git://#{node['gerrit']['hostname']}"
default['gerrit']['config']['database']['type'] = "MYSQL"
default['gerrit']['config']['database']['database'] = "gerrit"
default['gerrit']['config']['auth']['type'] = "HTTP"
default['gerrit']['config']['auth']['cookieSecure'] = true
default['gerrit']['config']['auth']['gitBasicAuth'] = true
default['gerrit']['batch_admin_user']['enabled'] = true
