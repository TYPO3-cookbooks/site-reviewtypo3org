control 'gerrit-proxy' do
  title 'Gerrit Proxy'

  [80, 443].each do |listen_port|
   describe port(listen_port) do
     it { should be_listening }
   end

    describe command("curl --insecure --head #{listen_port == 80 ? 'http' : 'https'}://localhost:#{listen_port}") do
      its('exit_status') { should eq 0 }
      its('stdout') { should include 'HTTP/1.1 301' }
      its('stdout') { should include 'Server: nginx' }
    end

  end

  describe command("curl --insecure https://review.vagrant") do
    its('exit_status') { should eq 0 }
    its('stdout') { should include '<title>Gerrit Code Review</title>' }
  end

  # Gerrit SSH 39418 -> 29418
  describe port(39418) do
    it { should be_listening }
    its('protocols') { should include 'tcp'}
  end
end

control 'gerrit-1' do
  title 'Gerrit Setup'
  desc '
    Check that gerrit is installed and running
  '
  describe file('/var/gerrit/review/etc/gerrit.config') do
    it { should exist }
  end

  describe ini('/var/gerrit/review/etc/gerrit.config') do
    its(['httpd', 'listenUrl']) { should cmp 'proxy-https://0.0.0.0:8080' }

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

end

