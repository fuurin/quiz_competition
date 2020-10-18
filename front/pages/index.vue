<template>
  <div>
    クイズ大会アプリへようこそ！
  </div>
</template>

<script>
const PAGE_TITLE = 'Index Page'

export default {
  mounted() {
    this.$nuxt.$emit('setTitle', PAGE_TITLE);
  },
}
</script>
