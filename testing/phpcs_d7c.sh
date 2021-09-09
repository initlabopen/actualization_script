#!/bin/bash
phpcs --config-set drupal_core_version 7
git fetch
#git branch -a
#git checkout $CI_MERGE_REQUEST_SOURCE_BRANCH_NAME
git merge origin/$CI_MERGE_REQUEST_TARGET_BRANCH_NAME --no-edit
paths="modules\/custom|themes\/custom"
extensions="php|inc|module|theme|install|css"
regex="^($paths)\/.+\.($extensions)$"
files=$(git diff-index --cached --name-only --diff-filter=ACMR origin/$CI_MERGE_REQUEST_TARGET_BRANCH_NAME | grep -E $regex || true)
if [ "$files" == "" ]; then  echo "no file match"; exit 0; fi
# The path of the top-level directory of the working tree.
base_path=$(git rev-parse --show-toplevel)
# Replace "|" with ",".
extensions=${extensions//[|]/,}
result=""
# Get and check the contents of the file version that will be commited.
for file_path in $files; do
          echo "$file_path"
         result+=$(phpcs --colors --standard=Drupal --basepath=$base_path --extensions=$extensions $file_path || true)
done
# Reject commit in case of errors.
if [ "$result" != "" ];
then
        echo "$result"
        exit 1
fi
