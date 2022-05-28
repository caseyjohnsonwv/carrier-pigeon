import boto3
import json
from os import getenv
from music import convert
import env

def lambda_handler(event=None, context=None):
    record = event['Records'][0]
    job_id = record['messageId']
    body = json.loads(record['body'])
    print(f"Body: {body}")

    # conversion happens in place
    convert(body)
    print(f"Body: {body}")

    object_key = f"{job_id}.json"
    local_json = f"/tmp/{object_key}"
    with open(local_json, 'w') as f:
        f.write(json.dumps(body))

    s3 = boto3.client('s3')
    s3.upload_file(local_json, env.S3_BUCKET_NAME, object_key)

    print(f"Uploaded {object_key} to {env.S3_BUCKET_NAME} bucket")