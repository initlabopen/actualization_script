set -e
ssh -p $1 $2@$3 "cd $4 && git reset HEAD "
ssh -p $1 $2@$3 "cd $4 && git checkout master"
ssh -p $1 $2@$3 "cd $4 && /usr/local/bin/php8.0 /home/m/medafarm/aloka.su/vendor/drush/drush/drush.php cex -y"
ssh -p $1 $2@$3 "cd $4 && git add config/"
ssh -p $1 $2@$3 "cd $4 && git commit -m 'Commit config files'"
ssh -p $1 $2@$3 "cd $4 && git push origin master"
