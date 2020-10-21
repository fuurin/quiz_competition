<template>
  <div>
    <h1>クイズ大会アプリ 管理画面へようこそ！</h1>
    <h2>E-mail: {{ admin.email }}</h2>
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
  mounted() {
    this.$nuxt.$emit('setTitle', PAGE_TITLE);
    
    // これはwebとadminを別アプリ化してそれぞれのアプリのplugin/axios.jsで設定したい。
    this.$axios.onRequest(config => {
      config.headers['client'] = this.admin.auth.client
      config.headers['access-token'] = this.admin.auth.accessToken
      config.headers['uid'] = this.admin.auth.uid
    })

    this.$axios.get('/quiz_sets')
      .then((res) => {
        this.quiz_sets = res.data;
      });
  },
  computed: {
    admin() {
      return this.$store.state.auth || {}
    }
  },
  methods: {
    signOut () {
      this.$store.dispatch('auth/signOut');
    }
  }
}
</script>