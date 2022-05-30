<template>
  <p>Your link is: <a>{{ this.shareable_link }}</a></p>
</template>

<script>
export default {
  name: 'Share',
  data() {
    return {
      playlist_link: this.$storage.getStorageSync("playlist_link"),
      shareable_link: location.href,
    };
  },
  methods: {
    
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
  font-weight: bold;
}

a:hover {
  color: #160c3bdd;
  cursor: pointer;
}
</style>