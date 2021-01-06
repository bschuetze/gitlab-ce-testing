#!/bin/bash

echo "-------------------------------"
echo "    RUNNING MOD FILE CHECK     "
echo "-------------------------------"

PWD_RUNNER=/CUSTOMS/pwd_patcher.sh
if [ ! -f "$PWD_RUNNER" ]; then
    cp /templates/pwd_patcher.sh /CUSTOMS/pwd_patcher.sh
fi

PAT_RUNNER=/CUSTOMS/pat_runner.sh
if [ ! -f "$PAT_RUNNER" ]; then
    cp /templates/pat_runner.sh /CUSTOMS/pat_runner.sh
fi

PAT_FILE=/CUSTOMS/default_pat.rb
if [ ! -f "$PAT_FILE" ]; then
    cp /templates/default_pat.rb /CUSTOMS/default_pat.rb
fi