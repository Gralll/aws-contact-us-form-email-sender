cd ..
if not exist "tmp" mkdir tmp

echo "****************Packaging SAM****************"
aws cloudformation package --template-file config/contact-us-email-sender.yml --output-template-file tmp/cf-contact-us-email-sender.yml --s3-bucket contact-us-email-sender-sam-euw1 --region eu-west-1

echo "****************Deploy CloudFormation resources****************"
aws cloudformation deploy --template-file tmp/cf-contact-us-email-sender.yml --stack-name ContactUsEmailService-dev-euw1 --capabilities CAPABILITY_IAM --region eu-west-1

echo "****************FINISH****************"
PAUSE