# Description

This cookbook deploys Gerrit for [review.typo3.org](https://review.typo3.org).

Apache HTTPD as well as MySQL are automatically installed an configured.

Further, automatic updates (by `gerrit init`) are supported.

# Requirements

## Platform:

*No platforms defined*

## Cookbooks:

* t3-base (~> 0.2.51)
* site-gittypo3org (~> 1.0.0)
* gerrit (~> 1.0.0)
* t3-gerrit (~> 1.0.0)
* t3-chef-vault (~> 1.0.0)
* t3-mysql (~> 0.1.3)
* php (= 1.5.0)
* ssh (= 0.6.6)
* build-essential (= 6.0.4)

# Attributes

* `node['gerrit']['version']` - Gerrit version. Defaults to `2.12.7`.
* `node['gerrit']['hostname']` - Gerrit host name. Defaults to `review.typo3.org`.
* `node['gerrit']['config']['gerrit']['canonicalWebUrl']` - Gerrit's URL (used in emails etc). Defaults to `https://#{node['gerrit']['hostname']}/`.
* `node['gerrit']['config']['gerrit']['canonicalGitUrl']` - Gerrit's Git URL (used in emails etc). Defaults to `git://#{node['gerrit']['hostname']}`.
* `node['gerrit']['config']['httpd']['listenUrl']` - Signal to Gerrit that our proxy speaks HTTPS. As gerrit::proxy sets this with 'normal' precedence, we have to 'override' here. Using ::1 instead of 127.0.0.1 prevents confusing inspec. Defaults to `proxy-https://[::1]:8080`.
* `node['gerrit']['config']['database']['type']` - Database type. Defaults to `MYSQL`.
* `node['gerrit']['config']['database']['database']` - Database name. Defaults to `gerrit`.
* `node['gerrit']['config']['auth']['type']` - Use HTTP for authentication. Defaults to `HTTP`.
* `node['gerrit']['config']['auth']['cookieSecure']` - Set cookieSecure attribute. Defaults to `true`.
* `node['gerrit']['config']['auth']['gitBasicAuth']` - Use HTTP basic auth for Git via HTTP (instead of additional HTTP passwords). Defaults to `true`.
* `node['gerrit']['batch_admin_user']['enabled']` - Automatically create a user in Gerrit for batch commands. Defaults to `true`.
* `node['git']['hostname']` - Git server hostname. Defaults to `git.typo3.org`.
* `node['git-daemon']['home']` - Git user's home directory. Defaults to `/var/git`.
* `node['git-daemon']['path']` - Path to Git repositories for Git Daemon. Defaults to `/var/git/repositories`.
* `node['gitweb']['path']` - Path to Git repositories for Gitweb. Defaults to `/var/git/repositories`.
* `node['gitweb']['hostname']` - Gitweb server hostname. Defaults to `git.typo3.org`.
* `node['gerrit']['theme']['compile_files']` - Gerrit theme files (that are reloaded on the fly). Defaults to `%w{`.
* `node['gerrit']['theme']['static_files']` - Gerrit theme files (that require a restart). Defaults to `%w{`.

# Recipes

* site-reviewtypo3org::default

Application Data
----------------

Application data resides in the following locations:

- MySQL data base (`gerrit`)
- Gerrit's git repos:
  - `/var/gerrit/review/git/`
- SSH host keys of Gerrit SSH:
  - `/var/gerrit/review/etc/ssh_host_{r,d}sa_key{,.pub}`
- SSH private keys for replication (otherwise auto-generated):
  - `/var/gerrit/.ssh/id_rsa-replication-*`
- [Secondary index](https://gerrit-documentation.storage.googleapis.com/Documentation/2.13/config-gerrit.html#index):
  - `/var/gerrit/review/index`
  - if empty, it has to be initialized using [offline reindex](https://gerrit-documentation.storage.googleapis.com/Documentation/2.13/pgm-reindex.html) first, which takes minutes to hours


For the included [site-gittypo3org](https://github.com/typo3-cookbooks/site-gittypo3org):

- Git daemon's git repos:
  - `/var/git/repositories/`

Styling
-------

For the theming we use gulp and sass. So please don't change the styles in the CSS-files.
Edit the .sass files and execute ```gulp --production```

This will compile your styles, put the changes to a new file with a new cache indentifier
and adjusts all templates and the configuration that uses the styles or js files.

If your new you should execute ```yarn install``` first to install everything you need for
development.

Backups
-------

Backups are covered by backuppc. No explicit backup mechanisms are implemented.

Build Status
------------

Build status on our [CI server](https://chef-ci.typo3.org):

- *master* (release): [![Build Status master branch](https://chef-ci.typo3.org/job/TYPO3-cookbooks/job/site-reviewtypo3org/branch/master/badge/icon)](https://chef-ci.typo3.org/job/TYPO3-cookbooks/job/site-reviewtypo3org/branch/master/)
- *develop* (next release): [![Build Status develop branch](https://chef-ci.typo3.org/job/TYPO3-cookbooks/job/site-reviewtypo3org/branch/develop/badge/icon)](https://chef-ci.typo3.org/job/TYPO3-cookbooks/job/site-reviewtypo3org/branch/develop/)


# License and Maintainer

Maintainer:: Steffen Gebert / TYPO3 Association (<steffen.gebert@typo3.org>)

License:: Apache 2.0
