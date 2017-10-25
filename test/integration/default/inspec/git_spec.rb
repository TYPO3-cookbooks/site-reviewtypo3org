require 'fileutils'

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
      its('protocols') { should include 'tcp'}
    end
  end

  work_dir = '/tmp/git-daemon_test-clone/'
  # can clone a repository
  describe command("git clone git://localhost/test/ #{work_dir}") do

    before do
      # command() only defines it in InSpec. Actually running happens once we ask for the result
      command("rm -rf #{work_dir}").result
    end

    its('exit_status') { should eq 0 }
  end

  # just make sure that we ran the recipe to copy over this file
  describe file('/tmp/push-repo.sh') do
    it { should exist }
    it { should be_executable }
  end

  # this script is added in test/fixtures/cookbooks/site-reviewtypo3org_test/recipes/push_repo_script.rb
  describe command("/tmp/push-repo.sh #{work_dir}") do
    # 42 means pushing failed
    its('exit_status') { should eq 42}
  end
end
