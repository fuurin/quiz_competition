<template>
  <div>
    <h1>
      クイズ大会アプリへようこそ！
    </h1>
    <v-btn class="mt-3" color="primary" to="/hello">HELLO</v-btn>
  </div>
</template>

<script>
const PAGE_TITLE = 'クイズ大会の名前'

export default {
  mounted() {
    this.$nuxt.$emit('setTitle', PAGE_TITLE)
  },
}
</script>
