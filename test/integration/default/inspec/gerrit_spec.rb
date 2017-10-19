control 'gerrit-1' do
  title 'Gerrit Setup'
  desc '
    Check that gerrit is installed and running
  '

  describe directory('/var/gerrit/review/etc') do
    it { should exist }
  end

  describe file('/var/gerrit/review/etc/gerrit.config') do
    it { should exist }
  end

  describe ini('/var/gerrit/review/etc/gerrit.config') do
    its(['gerrit', 'reportBugUrl']) { should cmp 'http://forge.typo3.org/projects/team-git' }
    its('database.type') { should cmp 'MYSQL' }
    its('auth.gitBasicAuth') { should cmp 'true' }
    its('gc.interval') { should cmp '3 days' }
    its('gc.startTime') { should cmp '3:00' }
    its('httpd.listenUrl') { should cmp 'http://0.0.0.0:8080/' }
    its('download.scheme') { should cmp 'anon_http' } # we can only check for the last occurrence wit the ini resource
    its('sendemail.from') { should cmp 'Gerrit Code Review <gerrit_dontreply@typo3.org>' }
    its('sendemail.includeDiff') { should cmp 'true' }
  end

  [8080, 29418].each do |listen_port|
    describe port(listen_port) do
      it { should be_listening }
      its('protocols') { should include 'tcp'}
    end
  end

  # port 8080 HTML
  describe command('curl http://localhost:8080') do
    its('exit_status') { should eq 0 }
    its('stdout') { should include '<title>Gerrit Code Review</title>' }
  end

  # check heap limit (defined in t3-gerrit)
  # jmap -heap <java-proc>
  describe command('sudo -H -u gerrit jmap -heap $(pgrep java) | grep MaxHeapSize') do
    skip "FIXME later"
    # its('stdout') { should include '2048.0MB' }
  end
end
