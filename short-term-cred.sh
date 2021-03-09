#!/bin/bash
# Generate Temp cred and promote it as a new profile
# Run script whenever the session token expired
set -e

tmp_file=$(mktemp /tmp/temp-cred.XXXXX)
aws sts get-session-token --serial-number arn:aws:iam::111111111111:mfa/my.mfa --token-code "$1" > "$tmp_file"

sed -i '/\[mfa\]/,/^\s*$/{d}' ~/.aws/credentials

cat<<EOF >>~/.aws/credentials
[mfa]
aws_access_key_id = $(cat ${tmp_file} | jq '.[] | .AccessKeyId' | sed 's/"//g')
aws_secret_access_key = $(cat ${tmp_file} | jq '.[] | .SecretAccessKey' | sed 's/"//g')
aws_session_token = $(cat ${tmp_file} | jq '.[] | .SessionToken' | sed 's/"//g')
EOF

rm $tmp_file
