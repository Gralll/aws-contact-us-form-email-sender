cd ..
mkdir tmp
cd lambda

echo "****************ZIP Lambda****************"
zip ../tmp/email-sender.zip email-sender.py

echo "****************Create S3 bucket****************"
if aws s3api head-bucket --bucket ses-sender 2>/dev/null; ( 
    aws s3 mb s3://ses-sender --region eu-west-1
)

echo "****************Upload lambdas to S3****************"
aws s3 cp ../tmp/email-sender.zip s3://email-sender
echo "****************FINISH****************"
PAUSE

