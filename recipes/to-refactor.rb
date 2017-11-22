edit_resource!(:template, "#{node['gerrit']['install_dir']}/etc/gerrit.config") do
  cookbook "site-reviewtypo3org"
end


# resources("template[#{node['gerrit']['install_dir']}/etc/gerrit.config]").cookbook cookbook_name

# TODO
# systemd unit
# heap space
# secure config
# include_recipe '::replication'
