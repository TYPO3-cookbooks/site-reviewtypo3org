control 'gerrit-2' do
  title 'Gerrit Proxy Setup'
  desc '
    Check that apache2 as proxy is installed and running
  '

  [80].each do |listen_port|
    describe port(listen_port) do
      it { should be_listening }
      its('protocols') { should include 'tcp6'}
    end
  end

  # port 80 HTML
  describe command('curl http://review.vagrant') do
    its('exit_status') { should eq 0 }
    its('stdout') { should include '<title>Gerrit Code Review</title>' }
  end

end
