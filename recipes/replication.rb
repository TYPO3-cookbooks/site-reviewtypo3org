# remove dots from our hostname to later query chef-vault
normalized_hostname = node['gerrit']['hostname'].gsub(/\./, '')

#### github.com

github_ssh_key = chef_vault_password('github.com', normalized_hostname, 'ssh_key')
gerrit_replication 'github-TYPO3-Extensions' do
  # this was via HTTPS (wtf?) in the old setup. Figure out, if it works with SSH as well..
  uri 'git@github.com:TYPO3-extensions/${name}.git'
  ssh_key github_ssh_key
end

gerrit_replication 'github-TYPO3-TYPO3.CMS' do
  uri 'git@github.com:TYPO3/TYPO3.CMS.git'
  ssh_key github_ssh_key
end

#### Git Server

ssh_key = chef_vault_password(node['git']['hostname'], normalized_hostname, 'ssh_key')
gerrit_replication 'git-typo3-org' do
  uri "#{node['git-daemon']['user']}@localhost:#{node['git-daemon']['home']}/repositories/${name}.git"
  ssh_key ssh_key
end

# place pubkey into /var/git/.ssh/
ssh_pubkey = chef_vault_password(node['git']['hostname'], normalized_hostname, 'ssh_pubkey')
directory File.join(node['git-daemon']['home'], '.ssh') do
  owner node['git-daemon']['user']
  group node['git-daemon']['group']
end
file File.join(node['git-daemon']['home'], '.ssh', 'authorized_keys') do
  content ssh_pubkey
  owner node['git-daemon']['user']
  group node['git-daemon']['group']
end

#### Forge

ssh_key = chef_vault_password('forge.typo3.org', normalized_hostname, 'ssh_key')
gerrit_replication 'forge-typo3-org' do
  uri 'git@forge.typo3.org:repositories/${name}.git'
  ssh_key ssh_key
end

#### replication config ####
# In a perfect world, above resources would also create the recplication.config.
# As file editing is a PITA and we're about to fade out Chef.. who cares. Here's
# the file.
template "#{node['gerrit']['install_dir']}/etc/replication.config" do
  source "gerrit/replication.config"
  owner node['gerrit']['user']
  group node['gerrit']['group']
  mode 0644
end
