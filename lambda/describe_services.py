# ----------------------------------------------------------------------------------------------------------------------
# Import Packages

import datetime as dt
import logging
import json
import os
import boto3

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
# Set Variables

S3_BUCKET = os.environ['S3_BUCKET']
S3_PREFIX = os.environ['S3_PREFIX']

# ----------------------------------------------------------------------------------------------------------------------
# Lambda Function

# pylint: disable=unused-argument

def main(event, context):

    # ------------------------------------------------------------------------------------------------------------------
    # Call Describe Services Endpoint from Boto3

    pricing_client = boto3.client('pricing', region_name='us-east-1')

    paginator = pricing_client.get_paginator('describe_services')

    response_iterator = paginator.paginate()

    service_list = []
    response_metadata_list = []

    for page in response_iterator:
        service_list += page['Services']
        response_metadata_list.append(page['ResponseMetadata'])

    logging.info('Boto3 ResponseMetadata: %s', response_metadata_list)

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
