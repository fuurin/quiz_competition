<template>
  <div>
    <v-btn color="secondary" @click="getMsg">Access API</v-btn>
    <div v-for="(msg, i) in msgs" :key="i">
      {{ msg }}
    </div>
  </div>
</template>

<script>
const PAGE_TITLE = '動作確認ページ';

export default {
  data () {
    return {
      msgs: []
    }
  },
  mounted() {
    this.$nuxt.$emit('setTitle', PAGE_TITLE);
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