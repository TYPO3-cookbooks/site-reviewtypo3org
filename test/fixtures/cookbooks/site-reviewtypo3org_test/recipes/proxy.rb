#node.default['nginx']['port'] = 8000
resources('service[apache2]').action [:disable, :stop]

log 'Notify service[apache2] to stop' do
  notifies :stop, 'service[apache2]'
  notifies :disable, 'service[apache2]'
end

node.default['site-proxytypo3org']['ssl_certificate'] = 'wildcard.vagrant'
include_recipe 'site-proxytypo3org'
