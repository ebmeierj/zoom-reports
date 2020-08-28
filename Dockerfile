FROM ruby:2.6-alpine3.11
MAINTAINER Firespring "info.dev@firespring.com"

# Set up the working directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Update to the latest available packages
RUN apk upgrade --available --no-cache

# Set up the UTC timezone
RUN apk -v --update add --no-cache tzdata
ENV TZ=UTC

# Update to version 2 of bundler
RUN gem update bundler

# Configure bundler to use multiple threads and retry if necessary
RUN bundle config --global jobs 12 && bundle config --global retry 3

# Install python3 and the awscli
RUN apk -v --update add --no-cache python3 \
    && pip3 install --upgrade --no-cache-dir awscli \
    && apk -v --update add --no-cache --virtual .crypto-deps build-base python3-dev openssl-dev libffi-dev \
    && pip3 install --upgrade --no-cache-dir aws-encryption-sdk-cli \
    && apk del .crypto-deps

# Install supervisor via pip
RUN pip3 install --upgrade --no-cache-dir supervisor

# Create the config directory
RUN mkdir -p /etc/supervisor.d/

# Install the master config
COPY supervisord.conf /etc/supervisord.conf

# Set env variables used by nginx
ENV PROXY_SOCKET="/run/proxy.sock" \
    NGINX_WORKERS=auto \
    NGINX_WORKER_CONNECIONS=1024 \
    NGINX_RLIMIT=2048 \
    NGINX_KEEPALIVE_TIMEOUT=60 \
    NGINX_KEEPALIVE_REQUESTS=1000 \
    CUSTOM_APP_PREFIX=_

# Install openssl and create default certificates
RUN apk -v --update --no-cache add openssl \
    && openssl req -x509 -nodes -days 365 -subj '/CN=sbf.dev' -sha256 -newkey rsa:2048 -keyout /etc/ssl/private/nginx.key -out /etc/ssl/certs/nginx.crt

# Install nginx
RUN apk -v --update --no-cache add gettext nginx

# Remove any configured sites
RUN rm -f /etc/nginx/conf.d/*

# Copy in our own nginx config template
COPY nginx.template /etc/nginx/nginx.template

# Copy in our custom scripts
COPY script/start_nginx.sh /etc/nginx/script/
COPY script/sub_env_vars_only.sh /etc/nginx/script/

# persistent packages
# * build-base is needed to build several of the gem bundles
# * curl is used by local health checks
# * git is needed by bundle audit
# * less is needed by pry
# * libxslt is needed by nokogiri
# * mariadb-dev and mariadb-connector-c are needed to build do-mysql
# * sqlite-dev is needed by do-sqlite3
RUN  apk -v --update --no-cache add build-base curl git less libxslt
RUN  apk -v --update --no-cache add mariadb-dev mariadb-connector-c sqlite-dev \
     && ln -s /usr/lib/libmariadb.so.3 /usr/lib/libmariadbclient.so.18

RUN apk -v --update add --no-cache yarn
ADD package.json .
ADD yarn.lock .
RUN yarn install

ENV PID_FILE=/var/run/zoomreports.pid

ADD Gemfile_native .
ADD Gemfile_native.lock .
RUN bundle install --gemfile Gemfile_native

ADD Gemfile .
ADD Gemfile.lock .
RUN bundle install
ADD . .

# Copy in our supervisor configs
COPY supervisor.d/* /etc/supervisor.d/

EXPOSE 443
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
CMD ["/usr/bin/supervisord"]
