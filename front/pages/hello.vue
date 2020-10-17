<template>
  <div>
    <button @click="getMsg">Access</button>
    <div v-for="(msg, i) in msgs" :key="i">
      {{ msg }}
    </div>
  </div>
</template>

<script>
export default {
  data () {
    return {
      msgs: []
    }
  },
  methods: {
    getMsg () {
      this.$axios.$get('/api/hello')
        .then(res => {
          this.msgs.push(res)
        });
    }
  }
}
</script>