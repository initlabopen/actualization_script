#!/bin/bash
set -e

USER="$1"
HOST="$2"
PORT="$3"
#dev
PATH_SOURCE="$4"
#prod
PATH_DEST="$5"

#echo "Copy sites/default/files"
#rsync -av -e "ssh -p $PORT -i ./.ssh/id_rsa_ci" "$USER"@"$HOST":"$PATH_DEST/sites/default/files/" "$PATH_SOURCE/sites/default/files/" --exclude 'settings.php' --exclude 'styles/'
echo "Create dump to $PATH_SOURCE/mysql/db.sql"
mkdir -p $PATH_SOURCE/mysql
ssh -i ./.ssh/id_rsa_ci -p $PORT "$USER"@"$HOST" drush --root=$PATH_DEST sql-dump > $PATH_SOURCE/mysql/db.sql
echo "Restore from dump $PATH_SOURCE/mysql/db.sql"
drush --root=$PATH_SOURCE sql-drop -y
drush --root=$PATH_SOURCE sql-cli < $PATH_SOURCE/mysql/db.sql
echo "Pull code"
cd $PATH_SOURCE
git reset --hard
git checkout master
git pull origin master
echo "Install site"
drush updb -y
drush cc all
