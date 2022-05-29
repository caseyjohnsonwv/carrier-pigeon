import boto3
import json
from os import getenv

s3_bucket_name = getenv('s3_bucket_name')

def lambda_handler(event=None, context=None):

    params = event['queryStringParameters']
    job_id = params['job_id']
    object_key = f"{job_id}.json"
    local_json = f"/tmp/{object_key}"

    print(f"Object key: {object_key}")

    s3 = boto3.client('s3')
    s3.download_file(s3_bucket_name, object_key, local_json)

    with open(local_json, 'r') as f:
        contents = json.loads(f.read())

    print(f"Contents: {contents}")

    return {
        'statusCode' : 200,
        'body' : json.dumps(contents),
        'headers' : {
            'Access-Control-Allow-Origin' : '*',
        }
    }