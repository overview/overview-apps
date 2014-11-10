#!/bin/sh
#
# Requires awscli (http://aws.amazon.com/cli/)
#
# Requires you set up CORS options to what AWS suggests when you click
# "Permissions" / "Add CORS Configuration"

set -e

aws s3 cp public/underscore.js s3://overview-keyword-stack/ --acl public-read --region us-east-1
aws s3 cp public/jquery-2.1.1.js s3://overview-keyword-stack/ --acl public-read --region us-east-1
aws s3 cp public/metadata.html s3://overview-keyword-stack/metadata --acl public-read --region us-east-1 --content-type text/html
aws s3 cp public/show.html s3://overview-keyword-stack/show --acl public-read --region us-east-1 --content-type text/html
