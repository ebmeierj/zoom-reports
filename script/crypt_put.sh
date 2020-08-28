#!/bin/bash
KEYID=$(aws ssm get-parameter --name /zoomreports/kms/id --query 'Parameter.Value' --output text)
aws ssm put-parameter --name "${1}" --type SecureString --value "${2}" --key-id "${KEYID}" --overwrite
