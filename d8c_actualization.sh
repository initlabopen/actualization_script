#!/bin/bash
set -e

USER="$1"
HOST="$2"
PORT="$3"
#dev
PATH_SOURCE="$4"
#prod
PATH_DEST="$5"

echo "Copy sites/default/files"
rsync -av -e "ssh -p $PORT -i ~/.ssh/id_rsa_ci" "$USER"@"$HOST":"$PATH_DEST/web/sites/default/files/" "$PATH_SOURCE/web/sites/default/files/" --exclude 'settings.php'
echo "Create dump to $PATH_SOURCE/mysql/db.sql"
mkdir -p $PATH_SOURCE/mysql
ssh -i ~/.ssh/id_rsa_ci -p $PORT "$USER"@"$HOST" drush --root=$PATH_DEST sql-dump > $PATH_SOURCE/mysql/db.sql
echo "Save configs if exists"
cd $PATH_SOURCE
git reset --hard
git checkout test
drush --root=$PATH_SOURCE cex -y
check_modify_files=$(git diff -q)
if [ -n "$check_modify_files" ]; then
  old_branch=$(git branch | grep "test-old")
  if [ "$old_branch" ]; then
  	git branch -D test-old
  fi
  git add config/sync
  git commit -m "add configs"
  git checkout -b test-old
fi
echo "Restore from dump $PATH_SOURCE/mysql/db.sql"
drush --root=$PATH_SOURCE sql-drop -y 
drush --root=$PATH_SOURCE sql-cli < $PATH_SOURCE/mysql/db.sql
echo "Pull code"
git checkout master
git pull origin master
git branch -D test
git checkout -b test
git push origin test --force
echo "Install site"
composer install
drush updb -y
drush cr
