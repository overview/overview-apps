#!/bin/sh
#
# Requires awscli (http://aws.amazon.com/cli/)
#
# Requires you set up CORS options to what AWS suggests when you click
# "Permissions" / "Add CORS Configuration"

set -e

for js in `ls public/*.js public/*.css`; do
  aws s3 cp $js s3://overview-keyword-noodle-soup/ --acl public-read --region us-east-1
done

aws s3 cp public/metadata.html s3://overview-keyword-noodle-soup/metadata --acl public-read --region us-east-1 --content-type text/html
aws s3 cp public/show.html s3://overview-keyword-noodle-soup/show --acl public-read --region us-east-1 --content-type text/html
