set -e
ssh -p $1 $2@$3 "cd $4 && git reset HEAD "
ssh -p $1 $2@$3 "cd $4 && git checkout master"
ssh -p $1 $2@$3 "cd $4 && drush cex -y"
ssh -p $1 $2@$3 "cd $4 && git add sites/config/"
ssh -p $1 $2@$3 "cd $4 && git commit -m 'Commit config files'"
ssh -p $1 $2@$3 "cd $4 && git push origin master"
