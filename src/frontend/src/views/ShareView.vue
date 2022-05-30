<template>
  <div class="wrapper">
    <Share/>
  </div>
</template>

<script>
// @ is an alias to /src
import Share from '@/components/Share.vue'

export default {
  name: 'ShareView',
  components: {
    Share
  }
}
</script>

<style>
.wrapper {
  position: relative;
}
</style>