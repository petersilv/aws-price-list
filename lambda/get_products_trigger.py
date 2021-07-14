# ----------------------------------------------------------------------------------------------------------------------
# Import Packages

import logging
import json
import os
import re
import itertools
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
S3_FILENAME = os.environ['S3_FILENAME']
SNS_TOPIC = os.environ['SNS_TOPIC']

# ----------------------------------------------------------------------------------------------------------------------
# Lambda Function

# pylint: disable=unused-argument

def main(event, context):

    # ------------------------------------------------------------------------------------------------------------------
    # Read Lookup From S3

    s3_client = boto3.client('s3')

    s3_response = s3_client.get_object(
        Bucket=S3_BUCKET,
        Key=f'{S3_PREFIX}{S3_FILENAME}'
    )

    lookup = s3_response['Body'].read().decode('utf-8') 
    lookup_dict = json.loads(lookup)

    # ------------------------------------------------------------------------------------------------------------------
    # Create List of Products from Lookup

    product_list = []

    for prd in lookup_dict['ProductFilters']:

        filters = {**prd, **lookup_dict['LocationFilters']}

        filters_as_lists = {
            k: [v] if not isinstance(v, list) else v
            for k, v 
            in filters.items() 
        }

        filters_all = [
            dict(zip(filters_as_lists.keys(), values)) 
            for values 
            in itertools.product(*filters_as_lists.values())
        ]

        product_list += filters_all

    # ------------------------------------------------------------------------------------------------------------------
    # Create SNS Messages from Product List

    message_list = []

    for product in product_list:

        params = {   
            'ServiceCode': product['servicecode'],
            'Filters':
            [
                { 'Type': 'TERM_MATCH', 'Field': key, 'Value': value }
                for key, value in product.items()
            ]
        }

        filepath_keys = ['location', 'servicecode', 'productFamily']
        filepath = ''

        for fp_key in filepath_keys:
            for key, value in product.items():
                if key == fp_key:
                    filepath += re.sub(r'[\(\)\s-]', '', f"{value}/")

        instance_flag = 0

        for key, value in product.items():
            if key == 'productFamily' and value == 'Compute Instance':
                instance_flag = 1

        message_list.append({
            'params': params, 
            'filepath': filepath,
            'instance_flag': instance_flag
        })

    # ------------------------------------------------------------------------------------------------------------------
    # Send to SNS

    sns_client = boto3.client('sns', region_name='eu-west-2')

    sns_response_list = []

    for message in message_list:

        sns_response = sns_client.publish(
            TopicArn=SNS_TOPIC, 
            Message=json.dumps(message)
        )

        sns_response_list.append(sns_response)

    logging.info('SNS Response: %s', sns_response_list)

    return message_list