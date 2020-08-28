#!/bin/sh
set -eo pipefail

main() {
  cd "$(dirname "$0")/"
  echo "Running Pre-Setup"

  if [ "${SSM_SECRET_KEY_BASE_PARAMETER}" != "" ]
  then
    echo "Loading ${SSM_SECRET_KEY_BASE_PARAMETER} from the Parameter Store"
    export SECRET_KEY_BASE="$(aws ssm get-parameter --name ${SSM_SECRET_KEY_BASE_PARAMETER} --with-decryption --query 'Parameter.Value' --output text)"
  else
    echo "SSM_SECRET_KEY_BASE_PARAMETER not found"
  fi

  if [ "${SSM_OAUTH_CLIENT_ID_PARAMETER}" != "" ]
  then
    echo "Loading ${SSM_OAUTH_CLIENT_ID_PARAMETER} from the Parameter Store"
    export OAUTH_CLIENT_ID="$(aws ssm get-parameter --name ${SSM_OAUTH_CLIENT_ID_PARAMETER} --with-decryption --query 'Parameter.Value' --output text)"
  else
    echo "SSM_OAUTH_CLIENT_ID_PARAMETER not found"
  fi

  if [ "${SSM_OAUTH_CLIENT_SECRET_PARAMETER}" != "" ]
  then
    echo "Loading ${SSM_OAUTH_CLIENT_SECRET_PARAMETER} from the Parameter Store"
    export OAUTH_CLIENT_SECRET="$(aws ssm get-parameter --name ${SSM_OAUTH_CLIENT_SECRET_PARAMETER} --with-decryption --query 'Parameter.Value' --output text)"
  else
    echo "SSM_OAUTH_CLIENT_SECRET_PARAMETER not found"
  fi

  if [ "${SSM_CERTIFICATE_CHAINED_AUTHORITY_PARAMETER}" != "" ]
  then
    echo "Loading ${SSM_CERTIFICATE_CHAINED_AUTHORITY_PARAMETER} from the Parameter Store"
    aws ssm get-parameter --name ${SSM_CERTIFICATE_CHAINED_AUTHORITY_PARAMETER} --with-decryption --query 'Parameter.Value' --output text
  else
    echo "SSM_CERTIFICATE_CHAINED_AUTHORITY_PARAMETER not found"
  fi

  if [ "${SSM_CERTIFICATE_KEY_PARAMETER}" != "" ]
  then
    echo "Loading ${SSM_CERTIFICATE_KEY_PARAMETER} from the Parameter Store"
    aws ssm get-parameter --name ${SSM_CERTIFICATE_KEY_PARAMETER} --with-decryption --query 'Parameter.Value' --output text
  else
    echo "SSM_CERTIFICATE_KEY_PARAMETER not found"
  fi

  echo "Executing: $@"
  exec "$@"
}

main "$@"
