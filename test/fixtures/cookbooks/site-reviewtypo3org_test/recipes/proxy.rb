#node.default['nginx']['port'] = 8000
resources('service[apache2]').action [:disable, :stop]

node.default['site-proxytypo3org']['ssl_certificate'] = 'wildcard.vagrant'
include_recipe 'site-proxytypo3org'
