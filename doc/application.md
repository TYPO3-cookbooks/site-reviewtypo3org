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