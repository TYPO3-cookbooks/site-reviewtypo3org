control 'gitweb-1' do
  title 'Gitweb HTTP access'
  desc 'Check that gitweb is installed and running'

  # gitweb access
  describe command('curl http://git.vagrant') do
    its('exit_status') { should eq 0 }
    its('stdout') { should include '<title>git.vagrant Git</title>' }
  end

  # gitweb access repository
  describe command('curl http://git.vagrant/test/') do
    its('exit_status') { should eq 0 }
    its('stdout') { should include '<title>git.vagrant Git - test/summary</title>' }
  end
end

control 'gitweb-2' do
  title 'Gitweb Git access'
  desc 'Interacting with Git through Gitweb'

  work_dir = '/tmp/gitweb_test-clone/'
  # can clone a repository
  describe command("git clone http://git.vagrant/test/ #{work_dir}") do

    before do
      # command() only defines it in InSpec. Actually running happens once we ask for the result
      command("rm -rf #{work_dir}").result
    end

    its('exit_status') { should eq 0 }
  end

  # this script is added in test/fixtures/cookbooks/site-reviewtypo3org_test/recipes/push_repo_script.rb
  describe command("/tmp/push-repo.sh #{work_dir}") do
    # 42 means pushing failed
    its('exit_status') { should eq 42}
  end


end