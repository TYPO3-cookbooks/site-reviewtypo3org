test_repo_path = File.join(node['git-daemon']['path'], "test")

execute "create bare repo" do
  command "git init --bare #{test_repo_path}"
  user node['git-daemon']['user']
  not_if { File.directory?(File.join(test_repo_path, "index")) }
end

file File.join(test_repo_path, "git-daemon-export-ok") do
  content ''
  user node['git-daemon']['user']
end