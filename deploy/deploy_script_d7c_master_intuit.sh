check_modify_files=$(ssh -p $1 $2@$3 "cd $4 && git diff -q")
echo "Modify Files = $check_modify_files"
if [ -n "$check_modify_files" ]; then echo "FIND MODIFY FILES"; exit 1; fi
ssh -p $1 $2@$3 "cd $4 && git reset --hard HEAD"
ssh -p $1 $2@$3 "cd $4 && git checkout master"
ssh -p $1 $2@$3 "cd $4 && git pull origin master"
ssh -p $1 $2@$3 "cd $4 && drush -u 1 updb -y --cache-clear=0"
