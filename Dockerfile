FROM postgres:10.4
LABEL maintainer="Benjamin Assadsolimani"

USER root

# Install NodeJS
RUN apt update && apt install -y curl unzip python-pip sqlite3
RUN sh -c 'curl -sL https://deb.nodesource.com/setup_10.x | bash -'
RUN apt install -y nodejs git

# Install rotate-backup utility
RUN pip install rotate-backups

# Install rclone utility
RUN echo "true" > /usr/local/bin/mandb && chmod 744 /usr/local/bin/mandb
RUN sh -c 'curl -sL https://rclone.org/install.sh | bash -'

WORKDIR /app/

# Set GPG home directory to data volume for persisting gpg configuration, keys, ...
ENV GNUPGHOME="/data/gnupg"
RUN mkdir -p ${GNUPGHOME}
RUN echo "allow-loopback-pinentry\n" > "${GNUPGHOME}/gpg-agent.conf"
RUN echo "use-agent\npinentry-mode loopback\n" > "${GNUPGHOME}/gpg.conf"
RUN chmod 700 ${GNUPGHOME}
VOLUME [ "/data" ]

ENV PATH="/app/node_modules/.bin:${PATH}"