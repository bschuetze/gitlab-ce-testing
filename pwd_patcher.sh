#!/bin/bash

echo "-------------------------------"
echo "      SETTING DEFAULT PWD      "
echo "-------------------------------"
if [ -z ${DEFAULT_ROOT_PWD} ]; then
    echo "DEFAULT_ROOT_PWD argument not provided, setting root password to 'password'";
else
    echo "Setting default root password to: ${DEFAULT_ROOT_PWD}";
fi

sed -i "s#\# gitlab_rails\['initial_root_password.*#gitlab_rails\['initial_root_password'\] = \""${DEFAULT_ROOT_PWD:-password}"\"#g" /etc/gitlab/gitlab.rb

if [ $? -eq 0 ]
then
  echo "Root default password set successfully"
else
  echo "Could set default root password" >&2
fi