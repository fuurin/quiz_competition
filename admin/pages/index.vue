<template>
  <div>
    <h1>クイズ大会アプリ 管理画面へようこそ！</h1>
    <h2>E-mail: {{ $store.state.auth.data.email }}</h2>
    <div v-for="quiz_set in quiz_sets" :key="quiz_set[0]" class="mt-3">
      <li>{{ quiz_set[0] }}: {{ quiz_set[1] }}</li>
    </div>
    <v-btn class="mt-3" color="primary" @click="signOut">ログアウト</v-btn>
  </div>
</template>

<script>
const PAGE_TITLE = 'クイズ大会アプリ 管理画面';

export default {
  data () {
    return {
      quiz_sets: []
    }
  },
  created() {
    this.$store.commit('page_title', PAGE_TITLE);
    this.$axios.get('/quiz_sets')
      .then((res) => {
        this.quiz_sets = res.data;
      });
  },
  methods: {
    signOut () {
      this.$store.dispatch('auth/signOut');
    }
  }
}
</script>