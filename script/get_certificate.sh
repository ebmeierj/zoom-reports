set -x

if [ -z $AWS_SESSION_TOKEN ]
then
  echo "You need a AWS_SESSION_TOKEN token set in your environment."
  echo "See https://github.com/firespring/sbf/blob/master/documentation/guides/aws/aws_cli.md"
  exit 1
fi

main () {
  local domains="$1"
  if [ -z $domains ]
  then
    echo "You need to specify the domains as the first argument to this script"
    exit 1
  fi

  local email="$2"
  if [ -z $email ]
  then
    echo "You need to specify the email as the second argument to this script"
    exit 1
  fi

  #Make sure the certbot image is up to date
  docker pull certbot/dns-route53

  echo
  echo Getting SSL Certs For:
  echo $domains | sed "s/,/\n/g"
  echo
  echo This process can take up to 10 minutes
  echo
  date

  # run the docker image to get the certs
  docker run -it --rm --name certbot \
    -e AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY \
    -e AWS_SESSION_TOKEN \
    -v "/etc/letsencrypt:/etc/letsencrypt" \
    certbot/dns-route53:latest \
    certonly \
      -n \
      --agree-tos \
      --dns-route53 \
      -d ${domains} \
      --email ${email} \
      --server https://acme-v02.api.letsencrypt.org/directory
  echo
}

main "$@"
