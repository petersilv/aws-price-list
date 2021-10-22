# ----------------------------------------------------------------------------------------------------------------------
# Import Packages

import datetime as dt
import logging
import json
import os
import boto3
from botocore.config import Config

# ----------------------------------------------------------------------------------------------------------------------
# Logging Setup

root = logging.getLogger()

if root.handlers:
    for handler in root.handlers:
        root.removeHandler(handler)

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

# ----------------------------------------------------------------------------------------------------------------------
# Boto3 Config Setup

CONFIG = Config(
   retries = {
      'max_attempts': 10,
      'mode': 'standard'
   }
)

# ----------------------------------------------------------------------------------------------------------------------
# Set Variables

S3_BUCKET = os.environ['S3_BUCKET']
S3_PREFIX = os.environ['S3_PREFIX']
SNS_TOPIC = os.environ['SNS_TOPIC']

# ----------------------------------------------------------------------------------------------------------------------
# Lambda Function

# pylint: disable=unused-argument

def main(event, context):

    # ------------------------------------------------------------------------------------------------------------------
    # Call Describe Services Endpoint from Boto3

    pricing_client = boto3.client('pricing', region_name='us-east-1', config=CONFIG)

    paginator = pricing_client.get_paginator('describe_services')

    response_iterator = paginator.paginate()

    service_list = []
    response_metadata_list = []

    for page in response_iterator:
        service_list += page['Services']
        response_metadata_list.append(page['ResponseMetadata'])

    logging.info('Boto3 ResponseMetadata: %s', response_metadata_list)

    # ------------------------------------------------------------------------------------------------------------------
    # Send to SNS

    sns_client = boto3.client('sns', region_name='eu-west-1')

    for service in service_list:

        sns_response = sns_client.publish(
            TopicArn=SNS_TOPIC, 
            Message=json.dumps(service)
        )

        # logging.info('SNS Response: %s', sns_response)

    # ------------------------------------------------------------------------------------------------------------------
    # Save to S3

    service_list_json = json.dumps(
        service_list,
        indent=4,
        ensure_ascii=False
    )

    s3_client = boto3.client('s3')

    filename = f"{dt.datetime.now().strftime('%Y-%m-%d')}.json"

    logging.info('S3 - Bucket: %s', S3_BUCKET)
    logging.info('S3 - Prefix: %s', S3_PREFIX)
    logging.info('S3 - File Name: %s', filename)

    s3_response = s3_client.put_object(
        Body=service_list_json,
        Bucket=S3_BUCKET,
        Key=f'{S3_PREFIX}{filename}',
    )

    s3_status_code = s3_response['ResponseMetadata']['HTTPStatusCode']
    logging.info('S3 - Status Code: %s', s3_status_code)

    return service_list
