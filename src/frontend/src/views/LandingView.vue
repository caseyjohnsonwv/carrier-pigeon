<template>
  <div class="wrapper">
    <Landing/>
  </div>
</template>

<script>
// @ is an alias to /src
import Landing from '@/components/Landing.vue'

export default {
  name: 'LandingView',
  components: {
    Landing
  }
}
</script>

<style>
.wrapper {
  position: relative;
}
</style>