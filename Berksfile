source "http://chef.typo3.org:26200"
source "https://supermarket.chef.io"

metadata

cookbook "ssh", github: "markolson/chef-ssh", ref: "0.6.6"
cookbook "gerrit", github: "TYPO3-cookbooks/gerrit", branch: "refactoring"
cookbook 't3-gerrit', git: 'ssh://review.typo3.org/Teams/Server/Chef.git', rel: 'site-cookbooks/t3-gerrit'
