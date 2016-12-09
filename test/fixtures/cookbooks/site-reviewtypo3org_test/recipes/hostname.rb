hostsfile_entry node['ipaddress'] do
  hostname 'review.vagrant'
  aliases ['git.vagrant']
end