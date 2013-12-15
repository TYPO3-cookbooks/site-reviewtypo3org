site :opscode

metadata

cookbook "mysql", "~> 3.0"

%w[
  gerrit
  ssl_certificates
].each do |cb|
  cookbook cb, github: "TYPO3-cookbooks/#{cb}"
end

