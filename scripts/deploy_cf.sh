#!/bin/bash
echo "********************************Create temp folder********************************"
cd ..

if [ ! -d temp ]; 
then
  mkdir -p temp;
fi

echo "Folder is ready"

echo "********************************Create S3 bucket********************************"

if aws s3api head-bucket --bucket email-sender-sam-euw1 2>/dev/null;
then
    echo "Bucket exists"
else 
	echo "Bucket not found";
	aws s3 mb s3://email-sender-sam-euw1 --region eu-west-1;
fi

echo "S3 bucket is ready"

echo "********************************Packaging SAM********************************"
aws cloudformation package --template-file config/contact-us-email-sender.yml --output-template-file temp/cf-contact-us-email-sender.yml --s3-bucket email-sender-sam-euw1 --region eu-west-1
echo "SAM is packaged"

echo "********************************Deploy CloudFormation resources********************************"
aws cloudformation deploy --template-file temp/cf-contact-us-email-sender.yml --stack-name ses-email-sender-dev-euw1 --capabilities CAPABILITY_IAM --region eu-west-1
echo "CF deployment finished"

echo "THE END"