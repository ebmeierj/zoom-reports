#!/bin/bash
set -eou pipefail
set -x

./get_certificate.sh "zoomreports.firespringdev.com" "info.dev@firespring.com"

# TODO: Upload certificate to ssm (and encrypt)
# TODO: Upload key and secret
