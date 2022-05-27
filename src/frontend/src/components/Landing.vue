<template>
  <div class="playlist-input">
    <div class="heading">
      <img src="../assets/bird.svg">
      <h1>Carrier Pigeon</h1>
      <p>Because sharing playlists between Apple Music and Spotify... is a lot like sending a carrier pigeon.</p>
    </div>
    <div class="user-form">
      <form action="submit" method="post" target="_blank">
        <input type="url" name="link" size="60" placeholder="Paste your playlist link here!">
      </form>
      <button type="submit" id="convert-button">Convert</button>
    </div>
    <div class="info">
      <a href="https://github.com/caseyjohnsonwv/carrier-pigeon/">Project source code</a>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Landing',
  props: {
    username: String
  },
  methods: {
    submit : function() {

    }
  }
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

::placeholder {
  color: #160c3b;
  opacity: 80%;
}

button {
  background-color: white;
  border: 1px solid #160c3b;
  border-radius: 0.5em;
  font-family: inherit;
  font-weight: bold;
  height: 4em;
  width: 12em;
}

button:hover {
  cursor: pointer;
  background-color: rgb(245, 245, 245);
}

.info {
  font-size: 0.9em;
  margin-top: 3em;
}

a {
  color: #160c3b;
}
</style>