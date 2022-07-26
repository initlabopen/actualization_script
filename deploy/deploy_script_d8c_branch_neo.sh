set -e
ssh -p $1 $2@$3 "cd $4/docroot && drush cex -y"
check_modify_files=$(ssh -p $1 $2@$3 "cd $4 && git diff --name-only")
echo "Modify Files = $check_modify_files"
if [ -n "$check_modify_files" ]; then echo "FIND MODIFY FILES"; exit 1; fi
ssh -p $1 $2@$3 "cd $4 && git reset --hard HEAD"
ssh -p $1 $2@$3 "cd $4 && git checkout test"
ssh -p $1 $2@$3 "cd $4 && git pull origin ${CI_COMMIT_BRANCH}"
ssh -p $1 $2@$3 "cd $4/docroot && composer install"
ssh -p $1 $2@$3 "cd $4/docroot && drush updatedb -y"
ssh -p $1 $2@$3 "cd $4/docroot && drush cache:rebuild"
ssh -p $1 $2@$3 "cd $4/docroot && drush config:import -y"
ssh -p $1 $2@$3 "cd $4/docroot && drush cache:rebuild"
