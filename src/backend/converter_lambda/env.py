from os import getenv


# lambda env vars
S3_BUCKET_NAME = getenv('S3_BUCKET_NAME')
APPLE_SECRETS_ASM = getenv('APPLE_SECRETS_ASM')
SPOTIFY_SECRETS_ASM = getenv('SPOTIFY_SECRETS_ASM')


# local env vars
from dotenv import load_dotenv
load_dotenv('.env')
APPLE_KEY_ID = getenv('APPLE_KEY_ID')
APPLE_SECRET_KEY = getenv('APPLE_SECRET_KEY')
APPLE_TEAM_ID = getenv('APPLE_TEAM_ID')
SPOTIFY_CLIENT_ID = getenv('SPOTIFY_CLIENT_ID')
SPOTIFY_CLIENT_SECRET = getenv('SPOTIFY_CLIENT_SECRET')


# replace local vars with ASM secrets
def load_asm_secret(secret_name:str) -> dict:
    import boto3
    import json
    client = boto3.client('secretsmanager')
    res = client.get_secret_value(
        SecretId = secret_name
    )
    return json.loads(res['SecretString'])

if APPLE_SECRETS_ASM:
    secrets = load_asm_secret(APPLE_SECRETS_ASM)
    APPLE_KEY_ID = secrets.get('APPLE_KEY_ID')
    APPLE_SECRET_KEY = secrets.get('APPLE_SECRET_KEY')
    APPLE_TEAM_ID = secrets.get('APPLE_TEAM_ID')

if SPOTIFY_SECRETS_ASM:
    secrets = load_asm_secret(SPOTIFY_SECRETS_ASM)
    SPOTIFY_CLIENT_ID = secrets.get('SPOTIFY_CLIENT_ID')
    SPOTIFY_CLIENT_SECRET = secrets.get('SPOTIFY_CLIENT_SECRET')