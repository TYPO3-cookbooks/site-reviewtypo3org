# includes our test harness

%w{
hostname
init_repo
push_repo_script
}.each do |recipe|
  include_recipe "::#{recipe}"
end