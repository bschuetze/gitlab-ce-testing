# Based on the original 12.9.10 dockerfile: https://gitlab.com/gitlab-org/omnibus-gitlab/-/blob/12.9.10+ce.0/docker/Dockerfile

FROM gitlab/gitlab-ce:12.9.10-ce.0

# Setup necessary locations and copy files
RUN mkdir /CUSTOMS
# COPY patched_wrapper /CUSTOMS/
# COPY custom_config.sh /CUSTOMS/
COPY pwd_patcher.sh /CUSTOMS/
COPY pat_runner.sh /CUSTOMS/
COPY default_pat.rb /CUSTOMS/
RUN chmod +x /CUSTOMS/pwd_patcher.sh
RUN chmod +x /CUSTOMS/pat_runner.sh

# Add patchers to the wrapper
RUN sed 's/echo "Configuring GitLab..."/source \/CUSTOMS\/pwd_patcher.sh\n\necho "Configuring GitLab..."/g' -i /assets/wrapper
RUN sed 's/gitlab-ctl reconfigure/gitlab-ctl reconfigure\n\nsource \/CUSTOMS\/pat_runner.sh/g' -i /assets/wrapper

# Expose customs folder
VOLUME ["/CUSTOMS"]

# RUN rm /assets/wrapper
# COPY /CUSTOMS/patched_wrapper /assets/wrapper

# FROM ubuntu:16.04
# LABEL maintainer Brent Schuetze <brent.schuetze@anu.edu.au>

# ARG DEFAULT_ROOT_PWD
# ARG DEFAULT_ROOT_TOKEN
# ARG DEFAULT_ROOT_TOKEN_SCOPE

# SHELL ["/bin/sh", "-c"],

# # Default to supporting utf-8
# ENV LANG=C.UTF-8

# # Install required packages
# RUN apt-get update -q \
#     && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
#       ca-certificates \
#       openssh-server \
#       wget \
#       apt-transport-https \
#       vim \
#       tzdata \
#       nano \
#     && rm -rf /var/lib/apt/lists/* \
#     && sed 's/session\s*required\s*pam_loginuid.so/session optional pam_loginuid.so/g' -i /etc/pam.d/sshd

# # Remove MOTD
# RUN rm -rf /etc/update-motd.d /etc/motd /etc/motd.dynamic
# RUN ln -fs /dev/null /run/motd.dynamic

# # Copy assets
# COPY RELEASE /
# COPY assets/ /assets/


# Before we run setup set the default password
# RUN if [ -z ${DEFAULT_ROOT_PWD} ]; then \
#     echo "DEFAULT_ROOT_PWD argument not provided, setting root password to 'password'"; \
# else \
#     echo "Setting default root password to: ${DEFAULT_ROOT_PWD}"; \
# fi
# RUN sed -i "s#\# gitlab_rails\['initial_root_password.*#gitlab_rails\['initial_root_password'\] = \""${DEFAULT_ROOT_PWD:-password}"\"#g" /assets/gitlab.rb


# RUN /assets/setup

# # Allow to access embedded tools
# ENV PATH /opt/gitlab/embedded/bin:/opt/gitlab/bin:/assets:$PATH

# # Resolve error: TERM environment variable not set.
# ENV TERM xterm

# # Expose web & ssh
# EXPOSE 443 80 22

# # Define data volumes
# VOLUME ["/etc/gitlab", "/var/opt/gitlab", "/var/log/gitlab"]

# # Wrapper to handle signal, trigger runit and reconfigure GitLab
# CMD ["/assets/wrapper"]

# Create default root access token
# COPY default_pat.rb /tmp/
# COPY pat_runner.sh  /tmp/

# RUN if [ -z ${DEFAULT_ROOT_TOKEN_SCOPE} ]; then \
#     echo "DEFAULT_ROOT_TOKEN_SCOPE argument not provided, setting token scope to all ('api', 'read_user', 'read_api', 'read_repository', 'write_repository')"; \
# else \
#     echo "Setting access token scope to: ${DEFAULT_ROOT_TOKEN_SCOPE}"; \
# fi
# RUN sed -i "s/token.scopes = \[\]/token.scopes = ${DEFAULT_ROOT_TOKEN_SCOPE:-\['api', 'read_user', 'read_api', 'read_repository', 'write_repository'\]})/g" /tmp/default_pat.rb

# COPY default_pat.rb /tmp/
# RUN if [ -z ${DEFAULT_ROOT_TOKEN} ]; then \
#     echo "DEFAULT_ROOT_TOKEN argument not provided, setting root access token to '9foA-QKCMgxSxf2iZZ2W'"; \
# else \
#     echo "Setting default root access token to: ${DEFAULT_ROOT_TOKEN}"; \
# fi
# RUN sed -i "s/token.set_token('')/token.set_token('${DEFAULT_ROOT_TOKEN:-9foA-QKCMgxSxf2iZZ2W}')/g" /tmp/default_pat.rb

# RUN chmod +x /tmp/pat_runner.sh
# RUN /tmp/pat_runner.sh

# RUN gitlab-rails r /tmp/default_pat.rb


# HEALTHCHECK --interval=60s --timeout=30s --retries=5 \
# CMD /opt/gitlab/bin/gitlab-healthcheck --fail --max-time 10
