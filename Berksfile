source "https://api.berkshelf.com"

metadata

cookbook "t3-chef-vault", github: "TYPO3-cookbooks/#{cb}"
cookbook "ssl_certificates", github: "TYPO3-cookbooks/#{cb}"
cookbook "gerrit", github: "TYPO3-cookbooks/gerrit", branch: "refactoring"
cookbook 't3-gerrit', git: 'ssh://review.typo3.org/Teams/Server/Chef.git', branch: 'feature/t3-gerrit-replication', rel: 'site-cookbooks/t3-gerrit'
