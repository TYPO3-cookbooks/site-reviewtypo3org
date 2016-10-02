name             "site-reviewtypo3org"
maintainer       "Steffen Gebert / TYPO3 Association"
maintainer_email "steffen.gebert@typo3.org"
license          "Apache 2.0"
description      "Installs/configures something"
version          "0.2.5"

depends "t3-base",           "~> 0.2.51"

depends "site-gittypo3org",  "~> 0.1.19"
depends "ssl_certificates",  "~> 1.1.0"
depends "gerrit",            "~> 0.6.0"
depends "t3-gerrit",         "~> 0.6.0"
depends "t3-chef-vault",     "~> 1.0.0"
depends "t3-mysql",          "~> 0.1.3"

depends "php",               "= 1.1.2"
depends "ssh",               "= 0.6.6"
depends "build-essential" ,  "= 6.0.4"
