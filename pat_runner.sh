#!/bin/bash

echo "-------------------------------"
echo "      RUNNING PAT PATCHER      "
echo "-------------------------------"

# Check if we have already created the PAT
CHK_FILE="/pat_check"
if [ -e ${CHK_FILE} ]; then
    run_pat=$(cat ${CHK_FILE})
else
    run_pat="0"
fi
if [ "${run_pat}" -eq "1" ]; then
    echo "PAT already created, skipping..."
    exit;
fi

PAT_FILE="/CUSTOMS/default_pat.rb"

if [ -z "${DEFAULT_ROOT_TOKEN}" ]; then
    echo "DEFAULT_ROOT_TOKEN argument not provided, setting root access token to '9foA-QKCMgxSxf2iZZ2W'";
else
    echo "Setting default root access token to: ${DEFAULT_ROOT_TOKEN}";
fi

sed -i "s/token.set_token('')/token.set_token('${DEFAULT_ROOT_TOKEN:-9foA-QKCMgxSxf2iZZ2W}')/g" ${PAT_FILE}

if [ -z "${DEFAULT_ROOT_TOKEN_SCOPE}" ]; then
    echo "DEFAULT_ROOT_TOKEN_SCOPE argument not provided, setting token scope to all ('api', 'read_user', 'read_repository', 'write_repository', 'sudo')";
else
    echo "Setting access token scope to: ${DEFAULT_ROOT_TOKEN_SCOPE}";
fi

sed -i "s/token.scopes = \[\]/token.scopes = ${DEFAULT_ROOT_TOKEN_SCOPE:-\['api', 'read_user', 'read_repository', 'write_repository', 'sudo'\]}/g" ${PAT_FILE}

gitlab-rails r ${PAT_FILE}

if [ $? -eq 0 ]
then
  echo "Successfully patched in default PAT"
  echo -n "1" > ${CHK_FILE}
else
  echo "Could not patch PAT"
fi

