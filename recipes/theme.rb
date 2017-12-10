node['gerrit']['theme']['compile_files'].each do |file|
  resources("cookbook_file[#{node['gerrit']['install_dir']}/etc/#{file}]").cookbook cookbook_name
end

node['gerrit']['theme']['static_files'].each do |file|
  resources("cookbook_file[#{node['gerrit']['install_dir']}/static/#{file}]").cookbook cookbook_name
end
