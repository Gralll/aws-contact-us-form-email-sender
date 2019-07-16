import json
import boto3
import os
from botocore.exceptions import ClientError


SUBJECT = "New ContactUs form request"
BODY_HTML_TEMPLATE = """
<html>
<head></head>
<body>
  <h1>Contact Us form from www.somesite.com</h1>
  <p>User name: {}</p>
  <p>User email: {}</p>
  <p>User phone: {}</p>
  <cite>Question: {}</cite>
</body>
</html>
"""         
CHARSET = "UTF-8"

def parseBody(event):
    return json.loads(event['body'])
    

def lambda_handler(event, context):
    SENDER = os.environ['SENDER_EMAIL']
    RECIPIENT = os.environ['RECIPIENT_EMAIL']
    AWS_REGION = os.environ['REGION']
    
    SES = boto3.client('ses',region_name=AWS_REGION)
    
    form = parseBody(event)
    body = BODY_HTML_TEMPLATE.format(form['username'], form['email'], form['phone'], form['question'])   
    try:
        response = SES.send_email(
            Destination={
                'ToAddresses': [
                    RECIPIENT
                ],
            },
            Message={
                'Body': {
                    'Html': {
                        'Charset': CHARSET,
                        'Data': body
                    }
                },
                'Subject': {
                    'Charset': CHARSET,
                    'Data': form.get('subject'),
                }
            },
            Source=SENDER
        )
    except ClientError as e:
        print(e.response['Error']['Message'])
        return {
            'headers': {
                'Access-Control-Allow-Origin': '*'
            },
            'statusCode': 500,
            'body': json.dumps({ 'message': 'Message delivery failed' })
        }
    else:
        print("Email sent! Message ID: {}".format(response.get('MessageId')))
        return {
            'headers': {
                'Access-Control-Allow-Origin': '*'
            },
            'statusCode': 200,
            'body': json.dumps({ 'message': 'Message with ID: {} was sent'.format(response.get('MessageId')) })
        }
