import applemusicpy
import json
import spotipy
from spotipy.oauth2 import SpotifyOAuth
from spotipy.cache_handler import CacheFileHandler
import env


def init_spotify():
    # initialize spotify auth
    cache_path = None if __name__ == '__main__' else '/tmp/.cache'
    token = SpotifyOAuth(
        client_id=env.SPOTIFY_CLIENT_ID,
        client_secret=env.SPOTIFY_CLIENT_SECRET,
        redirect_uri='localhost:8080/',
        scope=['playlist-read-private', 'playlist-read-collaborative'],
        cache_handler=CacheFileHandler(cache_path=cache_path),
    ).parse_response_code()
    sp = spotipy.Spotify(auth=token)
    return sp


def init_apple_music():
    # initialize apple auth
    am = applemusicpy.AppleMusic(
        key_id=env.APPLE_KEY_ID,
        secret_key=env.APPLE_SECRET_KEY,
        team_id=env.APPLE_TEAM_ID,
    )
    return am


def lambda_handler(event=None, context=None):

    sp = init_spotify()
    

    # return {
    #     'statusCode' : 200,
    #     'body' : json.dumps(contents),
    # }


if __name__ == '__main__':
    lambda_handler()