<template>
  <div>
    <form @submit.prevent="login">
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
  data() {
    return {
      email: '',
      password: ''
    }
  },
  mounted() {
    this.$nuxt.$emit('setTitle', PAGE_TITLE);
  },
  methods: {
    login() {
      this.$axios.post('/api/admin/auth/sign_in', {
        email: this.email,
        password: this.password
      })
      .then(res => {
        alert(`ログイン！\n${this.email}\n${this.password}`);
        console.log(res.data);
        console.log(res.headers);
      });
    }
  }
}
</script>
