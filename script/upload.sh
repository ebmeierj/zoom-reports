#!/bin/bash
set -eou pipefail
cd $(dirname $0)/

DOCKER_TAG="${DOCKER_TAG:-:latest}"

test() {
  bundle install
  rspec
  rubocop
}

build() {
  pushd ../
  docker-compose build
  popd
}

tag() {
  # Tag and push to aws
  docker tag zoomreports:latest ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/zoomreports:latest
}

push() {
  aws ecr get-login-password | docker login --password-stdin --username AWS "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
  docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/zoomreports:latest
}

#test
build
tag
push
