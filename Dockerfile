FROM gitlab/gitlab-ce:12.9.10-ce.0

# Setup necessary locations and copy files
RUN mkdir /CUSTOMS
COPY pwd_patcher.sh /CUSTOMS/
COPY pat_runner.sh /CUSTOMS/
COPY default_pat.rb /CUSTOMS/
# Max shell scripts runnable
RUN chmod +x /CUSTOMS/pwd_patcher.sh
RUN chmod +x /CUSTOMS/pat_runner.sh

# Add patchers to the existing wrapper
RUN sed 's/echo "Configuring GitLab..."/source \/CUSTOMS\/pwd_patcher.sh\n\necho "Configuring GitLab..."/g' -i /assets/wrapper
RUN sed 's/gitlab-ctl reconfigure/gitlab-ctl reconfigure\n\nsource \/CUSTOMS\/pat_runner.sh/g' -i /assets/wrapper

# Expose customs folder
VOLUME ["/CUSTOMS"]
