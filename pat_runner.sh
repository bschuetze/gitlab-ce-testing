#!/bin/bash

echo "-------------------------------"
echo "      RUNNING PAT PATCHER      "
echo "-------------------------------"

run_pat=`echo "User.find_by_username('root').personal_access_tokens.first.name" | gitlab-rails console | grep "api-token-for-testing" | wc -l`

if [ "${run_pat}" -eq "1" ]; then
    echo "PAT already created, skipping...";
    return 0;
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
    echo "Successfully patched in default PAT";
else
    echo "Could not patch PAT";
fi