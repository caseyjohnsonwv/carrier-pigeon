from dotenv import load_dotenv
load_dotenv('.env')

from os import getenv
APPLE_KEY_ID = getenv('APPLE_KEY_ID')
APPLE_SECRET_KEY = getenv('APPLE_SECRET_KEY')
APPLE_TEAM_ID = getenv('APPLE_TEAM_ID')
SPOTIFY_CLIENT_ID = getenv('SPOTIFY_CLIENT_ID')
SPOTIFY_CLIENT_SECRET = getenv('SPOTIFY_CLIENT_SECRET')