import applemusicpy
import json
import spotipy
from spotipy import CacheFileHandler
from spotipy.oauth2 import SpotifyClientCredentials
import env

# initialize spotify auth
cache_path = None if __name__ == '__main__' else '/tmp/.cache'
sp_auth_manager = SpotifyClientCredentials(
    client_id=env.SPOTIFY_CLIENT_ID,
    client_secret=env.SPOTIFY_CLIENT_SECRET,
    cache_handler=CacheFileHandler(cache_path=cache_path)
)
def init_spotify():
    token = sp_auth_manager.get_access_token(as_dict=False)
    sp = spotipy.Spotify(auth=token)
    return sp


#initialize apple music auth
# am = applemusicpy.AppleMusic(
#     secret_key=env.APPLE_SECRET_KEY,
#     key_id=env.APPLE_KEY_ID,
#     team_id=env.APPLE_TEAM_ID,
# )


def main():
    sample_url = 'https://open.spotify.com/track/4TlN2LSHn3DzauUe77l0ib?si=3991d682ad554cd6'
    isrc = isrc_from_track('spotify', sample_url)
    print(isrc)
    song = track_from_isrc('spotify', isrc)
    print(song)


def isrc_from_track(service:str, track_id:str):
    # get isrc for this track from its id / uri / url
    if service == 'spotify':
        sp = init_spotify()
        song = sp.track(track_id)
        if song is not None:
            return song['external_ids']['isrc']

    elif service == 'apple':
        # TODO
        pass


def track_from_isrc(service:str, isrc:str):
    # get this track's id on the selected service from its isrc
    if service == 'spotify':
        sp = init_spotify()
        query = f"isrc:{isrc}"
        res = sp.search(q=query, limit=1)
        if res is not None:
            return res['tracks']['items'][0]['id']
    
    elif service == 'apple':
        # TODO
        pass


if __name__ == '__main__':
    main()