<template>
  <div>
    <form @submit.prevent="sign_up" class="mt-6">
      <v-text-field v-model="name" label="名前（表示名）" required></v-text-field>
      <v-text-field v-model="email" label="メールアドレス" required></v-text-field>
      <v-text-field v-model="password" type="password" label="パスワード" required ></v-text-field>
      <v-text-field v-model="password_confirmation" type="password" label="パスワード確認" required ></v-text-field>
      <v-btn class="mt-3" type="submit">参加する</v-btn>
    </form>
  </div>
</template>

<script>
const PAGE_TITLE = 'クイズ大会に参加'

export default {
  head() {
    return { title: PAGE_TITLE }
  },
  validate({ params }) {
    return params.rid.length === 24
  },
  data() {
    return {
      name: '',
      email: '',
      password: '',
      password_confirmation: ''
    }
  },
  created() {
    this.$store.commit('page_title', PAGE_TITLE)
  },
  methods: {
    sign_up() {
      this.$store.dispatch('auth/authenticate', {
        action: '',
        params: {
          rid: this.$route.params.rid,
          name: this.name,
          email: this.email,
          password: this.password,
          password_confirmation: this.password_confirmation
        }
      })
    }
  }
}
</script>
