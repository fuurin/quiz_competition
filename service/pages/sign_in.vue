<template>
  <div>
    <form @submit.prevent="sign_in">
      <v-text-field v-model="email" label="メールアドレス" required></v-text-field>
      <v-text-field v-model="password" type="password" label="パスワード" required ></v-text-field>
      <v-btn class="mr-4" type="submit">ログイン</v-btn>
    </form>
  </div>
</template>

<script>
const PAGE_TITLE = 'ログイン'

export default {
  head() {
    return { title: PAGE_TITLE }
  },
  data() {
    return {
      email: '',
      password: ''
    }
  },
  created() {
    this.$store.commit('page_title', PAGE_TITLE)
  },
  methods: {
    sign_in() {
      this.$store.dispatch('auth/authenticate', {
        action: 'sign_in',
        params: {
          email: this.email,
          password: this.password
        }
      })
    }
  }
}
</script>
