#<> Gerrit version
default['gerrit']['version'] = "2.14.4"
#<> Gerrit host name
default['gerrit']['hostname'] = "review.typo3.org"
#<> Gerrit's URL (used in emails etc)
default['gerrit']['config']['gerrit']['canonicalWebUrl'] = "https://#{node['gerrit']['hostname']}/"
#<> Gerrit's Git URL (used in emails etc)
default['gerrit']['config']['gerrit']['canonicalGitUrl'] = "git://#{node['gerrit']['hostname']}"
#<> Signal to Gerrit that our proxy speaks HTTPS. As gerrit::proxy sets this with 'normal' precedence, we have to 'override' here. Using ::1 instead of 127.0.0.1 prevents confusing inspec.
override['gerrit']['config']['httpd']['listenUrl'] = 'http://0.0.0.0:8080/'
#<> Database type
default['gerrit']['config']['database']['type'] = "MYSQL"
#<> Database name
default['gerrit']['config']['database']['database'] = "gerrit"
#<> Set cookieSecure attribute
default['gerrit']['config']['auth']['cookieSecure'] = true
#<> Use HTTP basic auth for Git via HTTP (instead of additional HTTP passwords)
default['gerrit']['config']['auth']['gitBasicAuth'] = true
#<> Automatically create a user in Gerrit for batch commands
default['gerrit']['batch_admin_user']['enabled'] = false
#<> LDAP server
default['gerrit']['config']['ldap']['server'] = 'ldaps://ldap.typo3.org'
#<> LDAP username
default['gerrit']['config']['ldap']['username'] = 'cn=review.typo3.org,ou=services,dc=typo3,dc=org'

