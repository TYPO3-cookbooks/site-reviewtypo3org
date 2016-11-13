default['gerrit']['version'] = "2.12.6"

default['gerrit']['hostname'] = "review.typo3.org"

default['gerrit']['config']['gerrit']['canonicalWebUrl'] = "https://#{node['gerrit']['hostname']}/"
default['gerrit']['config']['gerrit']['canonicalGitUrl'] = "git://#{node['gerrit']['hostname']}"
#<> Signal to Gerrit that our proxy speaks HTTPS. As gerrit::proxy sets this with 'normal' precedence, we have to 'override' here.
override['gerrit']['config']['httpd']['listenUrl'] = "proxy-https://127.0.0.1:8080"

default['gerrit']['config']['database']['type'] = "MYSQL"
default['gerrit']['config']['database']['database'] = "gerrit"
default['gerrit']['config']['auth']['type'] = "HTTP"
default['gerrit']['config']['auth']['cookieSecure'] = true
default['gerrit']['config']['auth']['gitBasicAuth'] = true
default['gerrit']['batch_admin_user']['enabled'] = true
