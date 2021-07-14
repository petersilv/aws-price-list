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

# ----------------------------------------------------------------------------------------------------------------------
# Lambda Function

# pylint: disable=unused-argument

def main(event, context):

    message = json.loads(event['Records'][0]['Sns']['Message'])

    # ------------------------------------------------------------------------------------------------------------------
    # Call Get Attribute Values Endpoint from Boto3

    pricing_client = boto3.client('pricing', region_name='us-east-1', config=CONFIG)

    paginator = pricing_client.get_paginator('get_products')

    response_iterator = paginator.paginate(
        ServiceCode=message['params']['ServiceCode'],
        Filters=message['params']['Filters']
    )

    product_list = []

    for page in response_iterator:
        for item in page['PriceList']:
            product_list.append(json.loads(item))

    # ------------------------------------------------------------------------------------------------------------------
    # Save to S3

    product_list_json = json.dumps(
        product_list,
        indent=4,
        ensure_ascii=False
    )

    s3_client = boto3.client('s3')

    prefix = f"{S3_PREFIX}{message['filepath']}"
    filename = f"{dt.datetime.now().strftime('%Y-%m-%d')}.json"

    logging.info('S3 - Bucket: %s', S3_BUCKET)
    logging.info('S3 - Prefix: %s', prefix)
    logging.info('S3 - File Name: %s', filename)

    s3_response = s3_client.put_object(
        Body=product_list_json,
        Bucket=S3_BUCKET,
        Key=f'{prefix}{filename}',
    )

    s3_status_code = s3_response['ResponseMetadata']['HTTPStatusCode']
    logging.info('S3 - Status Code: %s', s3_status_code)

