file "/tmp/push-repo.sh" do
  content <<-EOQ
# this script will exit with
# - status code 0, if pushing SUCCEEDED 
# - status code 42, if pushing FAILED
# - other exit code, if something failed in between
WORKDIR=$1
cd $WORKDIR
pwd
touch TEST
git add TEST
git commit -m"Adding file"
git remote -v
(git push || exit 42)
  EOQ
  mode "0755"
end