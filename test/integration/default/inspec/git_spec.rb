control 'git-1' do
  title 'Git Setup'
  desc '
    Check that git is installed and running
  '

  describe directory('/var/git') do
    it { should exist }
  end

  [9418].each do |listen_port|
    describe port(listen_port) do
      it { should be_listening }
      its('protocols') { should include 'tcp6'}
    end
  end

  # gitweb access
  describe command('curl --resolve "git.vagrant:80:127.0.0.1" http://git.vagrant') do
    its('exit_status') { should eq 0 }
    its('stdout') { should include '<title>git.vagrant Git</title>' }
  end

end