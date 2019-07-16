#!/bin/bash
echo "****************Create temp folder****************"
cd ..
if [ ! -d temp ]; then
  mkdir -p temp;
fi
cd lambda

echo "****************ZIP Lambda****************"
zip ../temp/email-sender.zip email-sender.py


echo "****************Update Lambda****************"
cd ../temp
aws lambda update-function-code --function-name contact-us-email-sender --zip-file fileb://email-sender.zip

echo "****************FINISH****************"