####################################
# Hook files
####################################

#### patchset-created

forge_token = chef_vault_password('forgetypo3org', 'reviewtypo3org', 'token')
gerrit_hook 'patchset-created-update-forge-issue.php' do
  event 'patchset-created'
  source 'hooks/patchset-created.d/update-forge-issue.php'
  variables(token: forge_token)
end

interceptt3com_token = chef_vault_password('intercept.typo3.com', 'reviewtypo3org', 'token')
gerrit_hook 'patchset-created-intercept.typo3.com.php' do
  event 'patchset-created'
  source 'hooks/patchset-created.d/intercept.typo3.com.php'
  variables(token: interceptt3com_token)
end

#### change-merged

packagist_token = chef_vault_password('packagist.org', 'reviewtypo3org', 'token')
gerrit_hook 'change-merged-update-packagist.org.php' do
  event 'change-merged'
  source 'hooks/change-merged.d/update-packagist.org.php'
  variables(token: packagist_token)
end

gerrit_hook 'change-merged-trigger-docstypo3org.phpsh' do
  event 'change-merged'
  source 'hooks/change-merged.d/trigger-docstypo3org.phpsh'
end

#### mixed
t3bot_token = chef_vault_password('t3bot.de', 'reviewtypo3org', 'token')
%w{patchset-created change-merged}.each do |hook|
  gerrit_hook "#{hook}-t3bot.de.php" do
    event hook
    source "hooks/#{hook}.d/t3bot.de.php"
    variables(token: t3bot_token)
  end
end

####################################
# Dependencies for hooks
####################################

# change-merged.d/update-packagist.org.php
package ['php5-cli', 'php5-curl']
