<template>
</template>

<script>
import router from '@/router';
import SpotifyWebApi from 'spotify-web-api-js';

export default {
  name: 'Callback',
  data() {
    return {
      playlist_link: "",
      shareable_link: "",
    };
  },
  methods: {
    callback() {
      var service = this.$storage.getStorageSync("service")
      var code = this.$route.query.code
      if (code != null) {
        var data = {"service":service, "code":code}
        // POST TO API FOR OAUTH COMPLETION
        return this.axios.post(this.$api_url+"/auth", data)
          .then((res) => {
            this.$storage.setStorageSync("token", res.data.token)
          })
          .then(() => {
              // CALL PLAYLIST CONVERSION LOGIC
              this.convert()
          })
      }
    },
    convert() {
      this.playlist_link = this.$storage.getStorageSync("playlist_link")
      var source_tracks = []
      var playlist_name = null;
      if (this.playlist_link.includes("spotify")) {

        // CREATE SPOTIFY AUTH INSTANCE
        var sp = new SpotifyWebApi();
        var token = this.$storage.getStorageSync("token");
        sp.setAccessToken(token);

        // GET PLAYLIST ID FROM USER'S LINK
        var playlist_id = this.playlist_link
        playlist_id = playlist_id.substring(playlist_id.lastIndexOf('/') + 1)
        if (playlist_id.includes("?")) {
          playlist_id = playlist_id.substring(0, playlist_id.indexOf('?'))
        }

        // GET PLAYLIST INFO FROM SPOTIFY
        sp.getPlaylist(playlist_id)
          .then((res) => {
            playlist_name = res.name
            for (var i = 0; i < res.tracks.items.length; i++) {
              source_tracks.push(
                res.tracks.items[i].track.id
              );
            }
            return {
              "playlist_name" : playlist_name,
              "source_service" : "spotify",
              "target_service" : "apple",
              "source_track_list" : source_tracks,
            }
          })

        // SEND POST REQUEST TO /CONVERT
          .then((payload) => {
            return this.axios.post(this.$api_url + "/convert", payload);
          })
        
        // SET JOB ID IN VUE STATE
          .then((res) => {
            var job_id = res.data.SendMessageResponse.SendMessageResult.MessageId
            this.$storage.setStorageSync("job_id", job_id);
          })
      }
      else if (this.playlist_link.includes("apple")) {
        // TODO
      }
      else { 
        // not valid, do some css magic
      }      
    }
  },
  created() {
    setInterval(() => {
      if (this.$storage.getStorageSync("job_id") != null) {
        router.push('/share/' + this.$storage.getStorageSync("job_id"))
      }
    }, 1000)
    this.callback();
  }
}
</script>