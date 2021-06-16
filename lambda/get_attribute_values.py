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

    service = json.loads(event['Records'][0]['Sns']['Message'])

    # ------------------------------------------------------------------------------------------------------------------
    # Call Get Attribute Values Endpoint from Boto3

    service_code = service['ServiceCode']
    attributes_list = []

    pricing_client = boto3.client('pricing', region_name='us-east-1')

    paginator = pricing_client.get_paginator('get_attribute_values')

    for attribute_name in service['AttributeNames']:

        response_iterator = paginator.paginate(
            ServiceCode=service_code,
            AttributeName=attribute_name
        )

        attr_value_list = []
        response_metadata_list = []

        for page in response_iterator:

            attr_value_list += page['AttributeValues']
            response_metadata_list.append(page['ResponseMetadata'])

        logging.info(
            'Boto3 - ServiceCode: %s, AttributeName: %s, ResponseMetadata: %s', 
            service_code,
            attribute_name, 
            response_metadata_list
        )

        attributes_list.append(
            {
                'ServiceCode': service_code,
                'AttributeName': attribute_name,
                'AttributeValues': attr_value_list
            }
        )


    # ------------------------------------------------------------------------------------------------------------------
    # Save to S3

    attributes_list_json = json.dumps(
        attributes_list,
        indent=4,
        ensure_ascii=False
    )

    s3_client = boto3.client('s3')

    prefix = f"{S3_PREFIX}{service_code}/"
    filename = f"{dt.datetime.now().strftime('%Y-%m-%d')}.json"

    logging.info('S3 - Bucket: %s', S3_BUCKET)
    logging.info('S3 - Prefix: %s', prefix)
    logging.info('S3 - File Name: %s', filename)

    s3_response = s3_client.put_object(
        Body=attributes_list_json,
        Bucket=S3_BUCKET,
        Key=f'{prefix}{filename}',
    )

    s3_status_code = s3_response['ResponseMetadata']['HTTPStatusCode']
    logging.info('S3 - Status Code: %s', s3_status_code)

    return attributes_list
