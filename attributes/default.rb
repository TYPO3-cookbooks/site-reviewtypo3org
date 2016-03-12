default['gerrit']['version'] = "2.12.2"

default['gerrit']['hostname'] = "review.typo3.org"

default['gerrit']['config']['gerrit']['canonicalWebUrl'] = "https://#{node['gerrit']['hostname']}/"
default['gerrit']['config']['gerrit']['canonicalGitUrl'] = "git://#{node['gerrit']['hostname']}"
default['gerrit']['config']['database']['type'] = "MYSQL"
default['gerrit']['config']['database']['database'] = "gerrit"
default['gerrit']['config']['auth']['type'] = "HTTP"
default['gerrit']['config']['auth']['cookieSecure'] = true
default['gerrit']['config']['auth']['gitBasicAuth'] = true
default['gerrit']['batch_admin_user']['enabled'] = true
default['gerrit']['proxy']['ssl'] = true
default['gerrit']['proxy']['ssl_cabundle'] = "/etc/ssl_certs/wildcard.typo3.org.ca-bundle"
default['gerrit']['proxy']['ssl_certfile'] = "/etc/ssl_certs/wildcard.typo3.org.crt"
default['gerrit']['proxy']['ssl_keyfile'] = "/etc/ssl_certs/wildcard.typo3.org.key"
