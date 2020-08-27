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

ADD Gemfile .
ADD Gemfile.lock .
RUN bundle install
ADD . .
