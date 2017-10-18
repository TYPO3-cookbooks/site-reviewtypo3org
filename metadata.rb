name             "site-reviewtypo3org"
maintainer       "Steffen Gebert / TYPO3 Association"
maintainer_email "steffen.gebert@typo3.org"
license          "Apache 2.0"
description      "Installs/configures something"
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION')) rescue '0.0.1'

depends "t3-base",           "~> 0.2.67"

depends "site-gittypo3org",  "~> 1.0.0"
depends "gerrit",            "~> 2.0.0"
depends "t3-chef-vault",     "~> 1.0.0"
depends "t3-mysql",          "~> 0.1.3"

depends "ssh",               "= 0.6.6"
