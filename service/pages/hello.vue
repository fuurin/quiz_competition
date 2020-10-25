<template>
  <div>
    <v-btn color="secondary" @click="getMsg">Access API</v-btn>
    <div v-for="(msg, i) in msgs" :key="i" class="mt-3">
      {{ msg }}
    </div>
    <br>
    <v-btn class="mt-3" @click="$router.go(-1)">戻る</v-btn>
  </div>
</template>

<script>
const PAGE_TITLE = '動作確認ページ'

export default {
  head() {
    return { title: PAGE_TITLE }
  },
  data () {
    return {
      msgs: []
    }
  },
  mounted() {
    this.$nuxt.$emit('setTitle', PAGE_TITLE)
  },
  methods: {
    async getMsg () {
      const res = await this.$axios.get('/hello')
      this.msgs.push(res.data)
    }
  }
}
</script>