import pytest
import re
import boto3
import botocore
import json


def test_lambda_local():
# Set "running_locally" flag if you are running the integration test locally
running_locally = True

if running_locally:

    # Create Lambda SDK client to connect to appropriate Lambda endpoint
    lambda_client = boto3.client('lambda',
        region_name="eu-west-1",
        endpoint_url="http://127.0.0.1:3001",
        use_ssl=False,
        verify=False,
        config=botocore.client.Config(
            signature_version=botocore.UNSIGNED,
            retries={'max_attempts': 0},
        )
    )
else:
    lambda_client = boto3.client('lambda')


# Invoke your Lambda function as you normally usually do. The function will run
# locally if it is configured to do so
with open('event.json') as json_file:  
    payload = json.load(json_file)

response = lambda_client.invoke(
    FunctionName="ContactUsEmailServiceLambda",
    Payload=json.dumps(payload),
    InvocationType='RequestResponse')

# Verify the response
template = re.compile('Message with ID: .* was sent successfully')
assert template.search(response)