import applemusicpy
import json
import spotipy
from spotipy.oauth2 import SpotifyOAuth
from spotipy.cache_handler import CacheFileHandler
import env


def get_spotify_token(code:str):
    # complete spotify oauth
    cache_path = None if __name__ == '__main__' else '/tmp/.cache'
    token = SpotifyOAuth(
        client_id=env.SPOTIFY_CLIENT_ID,
        client_secret=env.SPOTIFY_CLIENT_SECRET,
        redirect_uri=env.OAUTH_REDIRECT_URI,
        scope=['playlist-read-private', 'playlist-read-collaborative'],
        cache_handler=CacheFileHandler(cache_path=cache_path),
    ).get_access_token(code, as_dict=False)
    return token


# def init_apple_music():
#     # initialize apple auth
#     am = applemusicpy.AppleMusic(
#         key_id=env.APPLE_KEY_ID,
#         secret_key=env.APPLE_SECRET_KEY,
#         team_id=env.APPLE_TEAM_ID,
#     )
#     return am


def lambda_handler(event=None, context=None):
    body = json.loads(event['body'])
    print(f"Body: {body}")

    response = {}

    service = str(body['service']).lower()
    if service == 'spotify':
        code = body['code']
        token = get_spotify_token(code)
        response['token'] = token

    elif service == 'apple':
        # TODO
        pass
    
    return {
        'statusCode' : 200,
        'body' : json.dumps(response),
    }
