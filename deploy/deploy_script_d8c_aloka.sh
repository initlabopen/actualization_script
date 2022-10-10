set -e
ssh -p $1 $2@$3 "cd $4 && /usr/local/bin/php8.0 /home/m/medafarm/aloka.su/vendor/drush/drush/drush.php cex -y"
check_modify_files=$(ssh -p $1 $2@$3 "cd $4 && git diff --name-only")
echo "Modify Files = $check_modify_files"
if [ -n "$check_modify_files" ]; then echo "FIND MODIFY FILES"; exit 1; fi
ssh -p $1 $2@$3 "cd $4 && git reset --hard HEAD"
ssh -p $1 $2@$3 "cd $4 && git checkout master"
ssh -p $1 $2@$3 "cd $4 && git pull origin master"
ssh -p $1 $2@$3 "cd $4 && /usr/local/bin/php8.0 /home/m/medafarm/aloka.su/bin/composer.phar install"
ssh -p $1 $2@$3 "cd $4 && /usr/local/bin/php8.0 /home/m/medafarm/aloka.su/vendor/drush/drush/drush.php updatedb:status -y"
ssh -p $1 $2@$3 "cd $4 && /usr/local/bin/php8.0 /home/m/medafarm/aloka.su/vendor/drush/drush/drush.php cache:rebuild"
ssh -p $1 $2@$3 "cd $4 && /usr/local/bin/php8.0 /home/m/medafarm/aloka.su/vendor/drush/drush/drush.php config:import -y"
ssh -p $1 $2@$3 "cd $4 && /usr/local/bin/php8.0 /home/m/medafarm/aloka.su/vendor/drush/drush/drush.php cache:rebuild"
