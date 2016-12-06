#<> Gerrit version
default['gerrit']['version'] = "2.12.7"
#<> Gerrit host name
default['gerrit']['hostname'] = "review.typo3.org"
#<> Gerrit's URL (used in emails etc)
default['gerrit']['config']['gerrit']['canonicalWebUrl'] = "https://#{node['gerrit']['hostname']}/"
#<> Gerrit's Git URL (used in emails etc)
default['gerrit']['config']['gerrit']['canonicalGitUrl'] = "git://#{node['gerrit']['hostname']}"
#<> Signal to Gerrit that our proxy speaks HTTPS. As gerrit::proxy sets this with 'normal' precedence, we have to 'override' here. Using ::1 instead of 127.0.0.1 prevents confusing inspec.
override['gerrit']['config']['httpd']['listenUrl'] = "proxy-https://[::1]:8080"
#<> Database type
default['gerrit']['config']['database']['type'] = "MYSQL"
#<> Database name
default['gerrit']['config']['database']['database'] = "gerrit"
#<> Use HTTP for authentication
default['gerrit']['config']['auth']['type'] = "HTTP"
#<> Set cookieSecure attribute
default['gerrit']['config']['auth']['cookieSecure'] = true
#<> Use HTTP basic auth for Git via HTTP (instead of additional HTTP passwords)
default['gerrit']['config']['auth']['gitBasicAuth'] = true
#<> Automatically create a user in Gerrit for batch commands
default['gerrit']['batch_admin_user']['enabled'] = true
