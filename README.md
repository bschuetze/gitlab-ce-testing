# Gitlab CE Docker Testing Image
This is basically a vanilla Gitlab CE docker image, however there are a few tweaks to allow you to set the default root password as well as a default personal access token to use with the API. This means that there is no need to manually interact with the web interface to set these things up.

## Environment Variables
| Variable | Default Value |
| -------- | ------------- |
| DEFAULT_ROOT_PWD | password |
| DEFAULT_ROOT_TOKEN | 9foA-QKCMgxSxf2iZZ2W |
| DEFAULT_ROOT_TOKEN_SCOPE | ['api', 'read_user', 'read_repository', 'write_repository', 'sudo'] |

## Example docker-compose.yml
```yml
version: "3"

services:
  gitlab:
    container_name: gitlab-tester
    image: "brentschuetze/gitlab-ce-testing:12.9.10-ce.0"
    hostname: "localhost"
    environment:
      # If you want to customize these then you can change them here, otherwise 
      # remove to set to default values
      DEFAULT_ROOT_PWD: PASSWORD_GOES_HERE # Password for 'root' account, min 8 chars
      DEFAULT_ROOT_TOKEN: VALID_TOKEN_GOES_HERE # API Token for root account
      DEFAULT_ROOT_TOKEN_SCOPE: "['api', 'read_user', 'read_repository']" 
      # A list containing any valid combination of scopes, see: 
      # https://docs.gitlab.com/ce/user/profile/personal_access_tokens.html#limiting-scopes-of-a-personal-access-token
    ports:
      - '8080:80' # Here 8080 is the local port and 80 is the port inside the container
      - '8443:443'
      - '8022:22'
    volumes:
      # Possible volume binds, not necessary (local mount point:container mount point)
      - "./gitlab-files/config:/etc/gitlab"
      - "./gitlab-files/logs:/var/log/gitlab"
      - "./gitlab-files/data:/var/opt/gitlab"
      - "./gitlab-files/customs:/CUSTOMS1"
    restart: unless-stopped
```
