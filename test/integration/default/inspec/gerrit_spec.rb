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
    its(['database', 'type']) { should cmp 'MYSQL' }
    its(['auth', 'gitBasicAuth']) { should cmp 'true' }
    its(['gc', 'interval']) { should cmp '3 days' }
    its(['gc', 'startTime']) { should cmp '3:00' }
    its(['httpd', 'listenUrl']) { should cmp 'http://*:8080/' } # even if we specify it without the trailing slash, `gerrit init` will add it
    its(['download', 'scheme']) { should cmp 'anon_http' } # we can only check for the last occurrence wit the ini resource
    its(['sendemail', 'from']) { should cmp 'Gerrit Code Review <gerrit_dontreply@typo3.org>' }
    its(['sendemail', 'includeDiff']) { should cmp 'true' }
    its(['ldap', 'password']) { should eq nil } # this has to be put into the secure.config
    its(['auth', 'restTokenPrivateKey']) { should eq nil } # this has to be put into the secure.config
  end

  describe ini('/var/gerrit/review/etc/secure.config') do
    its(['ldap', 'password']) { should eq 'thisIsTheLdapPassword' }
    its(['auth', 'restTokenPrivateKey']) { should eq '/V6BpquTuJ8StIG2/a7J5hC6T/0ScgZ/UaNKvkX3gkNXCmyf=' }
    its(['auth', 'registerEmailPrivateKey']) { should eq '3LvCMi6D0NGSGT0GCz1wuaeFploUYPcggt3LHYSd/MHiixfJ' }
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

  # check heap limit
  # jmap -heap <java-proc>
  #describe command('jmap -heap $(pgrep java) | grep MaxHeapSize') do
  #  its('stdout') { should include '6144.0MB' }
  #end

end


control 'gerrit-2' do
  title 'Gerrit Replication'
  desc 'Verifies correct replication setup'

  describe file('/var/gerrit/.ssh/replication_github.com') do
    it { should exist }
    its('content') { should eq 'privatekey123456github' }
    its('owner') { should eq 'gerrit'}
  end

  describe file('/var/gerrit/.ssh/known_hosts') do
    it { should exist }
    its('content') { should include 'github.com' }
  end

  describe command('ssh -o StrictHostKeyChecking=no -i /var/gerrit/.ssh/replication_localhost git@localhost true') do
    its('exit_status') { should eq 0 }
  end
end
