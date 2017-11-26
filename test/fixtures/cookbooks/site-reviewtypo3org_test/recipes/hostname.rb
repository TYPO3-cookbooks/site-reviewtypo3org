# does not work inside docker, until this is released:
# https://github.com/customink-webops/hostsfile/pull/78
# Current version 2.4.5 doesn't contain this.

#hostsfile_entry node['ipaddress'] do
#  hostname 'review.vagrant'
#  aliases ['git.vagrant']
#end

ruby_block "update /etc/hosts" do
  block do
    fe = Chef::Util::FileEdit.new("/etc/hosts")
    fe.insert_line_if_no_match(/review\.vagrant/,
                               "#{node['ipaddress']} #{node['hostname']} review.vagrant git.vagrant")
    fe.write_file
  end
end
