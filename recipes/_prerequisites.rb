include_recipe 't3-chef-vault'

# this has to be defined before including the gerrit cookbook
node.normal['gerrit']['secure_config']['ldap']['password'] = true
# TODO maybe use chef run_state to avoid storing this on the chef-server
ldap_server = URI(node['gerrit']['config']['ldap']['server']).host
node.normal['gerrit']['config']['ldap']['password'] = chef_vault_password(ldap_server, node['gerrit']['hostname'].gsub(/\./, ''))
node.normal['gerrit']['config']['auth']['registerEmailPrivateKey'] = chef_vault_password(node['gerrit']['hostname'], 'config', 'registerEmailPrivateKey')
node.normal['gerrit']['config']['auth']['restTokenPrivateKey'] = chef_vault_password(node['gerrit']['hostname'], 'config', 'restTokenPrivateKey')
