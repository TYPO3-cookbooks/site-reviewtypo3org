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

* `node['site-reviewtypo3org']['amqp']['server']` -  Defaults to `nil`.
* `node['site-reviewtypo3org']['amqp']['user']` -  Defaults to `nil`.
* `node['site-reviewtypo3org']['amqp']['vhost']` -  Defaults to `nil`.
* `node['site-reviewtypo3org']['mq-worker']['gerrit']['user']` -  Defaults to `gerrit-mq-worker`.
* `node['site-reviewtypo3org']['mq-worker']['gerrit']['user_fullname']` -  Defaults to `Gerrit MQ Worker`.
* `node['site-reviewtypo3org']['mq-worker']['gerrit']['user_email']` -  Defaults to `admin+gerrit-mq-worker@typo3.org`.
* `node['site-reviewtypo3org']['amqp']` -  Defaults to `{ ... }`.
* `node['gerrit']['version']` -  Defaults to `2.12.6`.
* `node['gerrit']['hostname']` -  Defaults to `review.typo3.org`.
* `node['gerrit']['config']['gerrit']['canonicalWebUrl']` -  Defaults to `https://#{node['gerrit']['hostname']}/`.
* `node['gerrit']['config']['gerrit']['canonicalGitUrl']` -  Defaults to `git://#{node['gerrit']['hostname']}`.
* `node['gerrit']['config']['httpd']['listenUrl']` - Signal to Gerrit that our proxy speaks HTTPS. As gerrit::proxy sets this with 'normal' precedence, we have to 'override' here. Defaults to `proxy-https://127.0.0.1:8080`.
* `node['gerrit']['config']['database']['type']` -  Defaults to `MYSQL`.
* `node['gerrit']['config']['database']['database']` -  Defaults to `gerrit`.
* `node['gerrit']['config']['auth']['type']` -  Defaults to `HTTP`.
* `node['gerrit']['config']['auth']['cookieSecure']` -  Defaults to `true`.
* `node['gerrit']['config']['auth']['gitBasicAuth']` -  Defaults to `true`.
* `node['gerrit']['batch_admin_user']['enabled']` -  Defaults to `true`.
* `node['git']['hostname']` -  Defaults to `git.typo3.org`.
* `node['git-daemon']['home']` -  Defaults to `/var/git`.
* `node['git-daemon']['path']` -  Defaults to `/var/git/repositories`.
* `node['gitweb']['path']` -  Defaults to `/var/git/repositories`.
* `node['gitweb']['hostname']` -  Defaults to `git.typo3.org`.
* `node['gerrit']['theme']['compile_files']` -  Defaults to `%w{`.
* `node['gerrit']['theme']['static_files']` -  Defaults to `%w{`.

# Recipes

* site-reviewtypo3org::amqp-publisher
* site-reviewtypo3org::default

Application Data
----------------

Application data resides in the following locations:

- MySQL data base (`gerrit`)
- Gerrit's git repos:
  - `/var/gerrit/review/git/`
- SSH host keys of Gerrit SSH:
  - `/var/gerrit/review/etc/ssh_host_{r,d}sa_key{,.pub}`
- [Secondary index](https://gerrit-documentation.storage.googleapis.com/Documentation/2.13/config-gerrit.html#index):
  - `/var/gerrit/review/index`
  - if empty, it has to be initialized using [offline reindex](https://gerrit-documentation.storage.googleapis.com/Documentation/2.13/pgm-reindex.html) first, which takes minutes to hours


For the included [site-gittypo3org](https://github.com/typo3-cookbooks/site-gittypo3org):

- Git daemon's git repos:
  - `/var/git/repositories/`

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
