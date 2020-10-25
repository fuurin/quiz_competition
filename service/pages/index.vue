<template>
  <div>
    <h1>
      クイズ大会アプリへようこそ！
    </h1>
    <v-btn class="mt-3" color="primary" to="/sign_in">ログイン</v-btn>
  </div>
</template>

<script>
const PAGE_TITLE = 'クイズ大会アプリ'

export default {
  created() {
    this.$store.commit('page_title', PAGE_TITLE)
  },
}
</script>
