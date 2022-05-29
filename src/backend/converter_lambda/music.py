import applemusicpy
import json
import spotipy
from spotipy import CacheFileHandler
from spotipy.oauth2 import SpotifyClientCredentials
import env


def init_spotify():
    # initialize spotify auth
    cache_path = None if __name__ == '__main__' else '/tmp/.cache'
    sp_auth_manager = SpotifyClientCredentials(
        client_id=env.SPOTIFY_CLIENT_ID,
        client_secret=env.SPOTIFY_CLIENT_SECRET,
        cache_handler=CacheFileHandler(cache_path=cache_path)
    )
    token = sp_auth_manager.get_access_token(as_dict=False)
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



# payload = {
#     "playlist_name" : "test playlist",
#     "source_service" : "apple",
#     "target_service" : "spotify",
#     "source_track_list" : [
#         "1623855917"
#     ]
# }


def convert(payload:dict):
    # actual conversion logic - modifies payload in-place
    payload['target_track_list'] = []
    source_service=str(payload['source_service']).lower()
    target_service=str(payload['target_service']).lower()

    for track_id in payload['source_track_list']:
        try:
            isrc = isrc_from_track(
                service=source_service,
                track_id=track_id
            )
        except Exception:
            print(f"Could not find track {track_id} on {source_service}")
            continue

        track = track_from_isrc(
            service=target_service, 
            isrc=isrc
        )
        if track is None:
            print(f"Track {track_id} (ISRC: {isrc}) is not available on {target_service}")
        else:
            payload['target_track_list'].append(track)
            
    return payload



def isrc_from_track(service:str, track_id:str):
    # get this track's isrc from its id on the selected service
    if service == 'spotify':
        sp = init_spotify()
        res = sp.track(track_id)
        if res is not None:
            return res['external_ids']['isrc']

    elif service == 'apple':
        am = init_apple_music()
        res = am.song(track_id)
        if res is not None:
            return res['data'][0]['attributes']['isrc']


def track_from_isrc(service:str, isrc:str):
    # get this track's id on the selected service from its isrc
    if service == 'spotify':
        sp = init_spotify()
        query = f"isrc:{isrc}"
        res = sp.search(q=query, limit=1)
        if res is not None:
            return res['tracks']['items'][0]['id']
    
    elif service == 'apple':
        am = init_apple_music()
        res = am.songs_by_isrc([isrc])
        if res is not None:
            return res['data'][0]['attributes']['url']


# if __name__ == '__main__':
#     convert(payload)
#     print(payload)