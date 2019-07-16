#!/bin/bash
echo "****************Create temp folder****************"
cd ..
if [ ! -d temp ]; then
  mkdir -p temp;
fi
cd lambda

echo "****************ZIP Lambda****************"
zip ../temp/email-sender.zip email-sender.py

echo "****************Create S3 bucket****************"
if aws s3api head-bucket --bucket email-sender-gralll 2>/dev/null;
then
    echo "Bucket exists"
else 
	echo "Bucket not found";
	aws s3 mb s3://email-sender-gralll --region eu-west-1;
fi

echo "****************Upload lambda to S3****************"
aws s3 cp ../temp/email-sender.zip s3://email-sender-gralll

echo "****************FINISH****************"