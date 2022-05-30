<template>
  <div class="playlist-input">
    <div class="heading">
      <img src="../assets/bird.svg">
      <h1>Playlist Pigeon</h1>
      <p>Because sharing playlists between Apple Music and Spotify... is a lot like sending a carrier pigeon.</p>
    </div>
    <div class="user-form">
      <form>
        <input v-model="playlist_link" type="url" size="60" placeholder="Paste your playlist link here!">
      </form>
      <button @click="get_auth">Convert</button>
    </div>
    <div class="info">
      <a href="https://github.com/caseyjohnsonwv/playlist-pigeon/">Project source code</a>
    </div>
  </div>
</template>

<script>
const querystring = require('querystring')

export default {
  name: 'Landing',
  data() {
    return {
      playlist_link: "",
    };
  },
  methods: {
    get_auth(event) {
      if (this.playlist_link.length > 0) {
        this.$storage.removeStorageSync("playlist_link")
        this.$storage.removeStorageSync("shareable_link")
        this.$storage.setStorageSync("playlist_link", this.playlist_link)
        if (this.playlist_link.includes("spotify")) {
          this.$storage.setStorageSync("service", "spotify");
          window.location.href = 'https://accounts.spotify.com/authorize?' +
            querystring.stringify({
              response_type: 'code',
              client_id: "d614ade3b49f4fdc822842b3fabc4db0",
              scope: "playlist-read-private, playlist-read-collaborative",
              redirect_uri: location.href + "callback",
            });
        }
        else if (this.playlist_link.includes("apple")) {
          // TODO
        }
        else {
          // not valid, do some css magic
        }
      }
    },
  },
}
</script>

<style>
body {
  background-color: #e6e6fa;
  color: #160c3b;
}

img {
  width: 5em;
  margin-bottom: -1.5em;
}

h1 {
  font-size: 3em;
  margin: 0;
}

.heading > p {
  font-size: 0.75em;
  font-style: italic;
  margin-top: 0em;
}

.user-form {
  margin: 5em 0em;
}

form {
  margin: 1em;
}

input {
  background-color: inherit;
  border: 0;
  border-bottom: 1px solid #160c3b;
  color: #160c3b;
  font-size: 1.2em;
  height: 1.5em;
  outline-width: 0;
  text-align: center;
}

input:hover {
  color: #160c3bdd;
}

::placeholder {
  color: #160c3b;
  opacity: 80%;
}

button {
  background-color: #160c3b;
  border: 1px solid white;
  border-radius: 0.5em;
  color: #e6e6fa;
  font-family: inherit;
  height: 4em;
  width: 12em;
}

button:hover {
  cursor: pointer;
  background-color: #160c3bdd;
}

.info {
  font-size: 0.9em;
  margin-top: 3em;
}

a {
  color: #160c3b;
}

a:hover {
  color: #160c3bdd;
  cursor: pointer;
}
</style>