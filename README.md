<p align="center">
  <a href="https://dev.to/vumdao">
    <img alt="Generate AWS Temporary Credential And Add It As A Profile" src="https://github.com/vumdao/gen-aws-temp-cred/blob/master/cover.png?raw=true" width="700" />
  </a>
</p>
<h1 align="center">
  <div><b>Generate AWS Temporary Credential And Add It As A Profile</b></div>
</h1>

### 🚀 **Beside AWS SSO, we can use auto script to generate temporary credential and add it as `[mfa]` profile**
Ref: https://aws.amazon.com/premiumsupport/knowledge-center/authenticate-mfa-cli/

```
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
```

### 🚀 **Test**

```
⚡ $ ./short-term-cred.sh 1234

⚡ $ cat ~/.aws/credentials
[default]
aws_access_key_id = example-access-key
aws_secret_access_key = example-secret-access


[mfa]
aws_access_key_id = example-access-key-as-in-returned-output
aws_secret_access_key = example-secret-access-key-as-in-returned-output
aws_session_token = example-session-Token-as-in-returned-output
```

```
⚡ $ aws elbv2 describe-target-groups --region ap-northeast-1 --profile mfa | grep TargetGroupArn | wc -l 
35
```

---

<h3 align="center">
  <a href="https://dev.to/vumdao">:stars: Blog</a>
  <span> · </span>
  <a href="https://github.com/vumdao/">Github</a>
  <span> · </span>
  <a href="https://vumdao.hashnode.dev/">Web</a>
  <span> · </span>
  <a href="https://www.linkedin.com/in/vu-dao-9280ab43/">Linkedin</a>
  <span> · </span>
  <a href="https://www.linkedin.com/groups/12488649/">Group</a>
  <span> · </span>
  <a href="https://www.facebook.com/CloudOpz-104917804863956">Page</a>
  <span> · </span>
  <a href="https://twitter.com/VuDao81124667">Twitter :stars:</a>
</h3>
