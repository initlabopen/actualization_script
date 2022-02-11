#!/bin/bash

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
ssh -i ~/.ssh/id_rsa_ci -p $PORT "$USER"@"$HOST" /usr/bin/drush --root=$PATH_DEST/web sql-dump > $PATH_SOURCE/mysql/db.sql
echo "Restore from dump $PATH_SOURCE/mysql/db.sql"
drush9 --root=$PATH_SOURCE sql-drop -y 
drush9 --root=$PATH_SOURCE sql-cli < $PATH_SOURCE/mysql/db.sql
echo "Pull code"
cd $PATH_SOURCE
git reset --hard
git checkout master
git pull origin master
echo "Install site"
composer install
drush9 updb -y
drush9 cr
