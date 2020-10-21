<template>
  <div>
    <form @submit.prevent="signIn">
      <v-text-field
        v-model="email"
        label="メールアドレス"
        required
      ></v-text-field>
      <v-text-field
        v-model="password"
        type="password"
        label="パスワード"
        required
      ></v-text-field>
      <v-btn class="mr-4" type="submit">ログイン</v-btn>
    </form>
  </div>
</template>

<script>
const PAGE_TITLE = '管理画面ログイン'

export default {
  head() {
    return { title: 'ログイン' };
  },
  data() {
    return {
      email: '',
      password: ''
    }
  },
  created() {
    this.$nuxt.$emit('setTitle', PAGE_TITLE);
  },
  methods: {
    signIn() {
      this.$store.dispatch('auth/signIn', {
        email: this.email,
        password: this.password
      });
    }
  }
}
</script>
