<template>
  <div>
    <h1>管理画面へようこそ！</h1>
    <h2>E-mail: {{ admin.email }}</h2>
    <v-btn class="mt-3" color="primary" @click="signOut">ログアウト</v-btn>
  </div>
</template>

<script>
const PAGE_TITLE = 'クイズ大会アプリ 管理画面';

export default {
  head() {
    return { title: '管理画面' }
  },
  layout () {
    return 'admin'
  },
  mounted() {
    this.$nuxt.$emit('setTitle', PAGE_TITLE);
  },
  computed: {
    admin() {
      return this.$store.state.admin || {}
    }
  },
  methods: {
    signOut () {
      this.$store.dispatch('admin/signOut');
    }
  }
}
</script>