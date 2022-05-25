import boto3
import json
from os import getenv

s3_bucket_name = getenv('s3_bucket_name')

def lambda_handler(event=None, context=None):
    record = event['Records'][0]
    job_id = record['messageId']
    body = json.loads(record['body'])
    print(f"Body: {body}")

    # TODO: conversion from one service to another

    object_key = f"{job_id}.json"
    local_json = f"/tmp/{object_key}"
    with open(local_json, 'w') as f:
        f.write(json.dumps(body))

    s3 = boto3.client('s3')
    s3.upload_file(local_json, s3_bucket_name, object_key)

    print(f"Uploaded {object_key} to {s3_bucket_name} bucket")