<template>
  <v-container class="ma-3">
    クイズ大会 運営画面
    <p>{{ status }}</p>
    <p>{{ quiz }}</p>
    <p>{{ options }}</p>
    <v-btn @click="close">終了</v-btn>
  </v-container>
</template>

<script>
export default {
  head() {
    return { title: 'クイズ大会 運営画面' }
  },
  // validate({ params }) {
  //   return params.rid.length === 24
  // },
  data () {
    return {
      status: null,
      quiz: {},
      options: []
    }
  },
  created() {
    this.$axios.get(`/competitions/${this.$route.params.rid}`)
      .then((res) => {
        this.status = res.data.status
        if (this.status !== 'question' && this.status !== 'answer') return
        this.quiz = res.data.quiz
        this.options = res.data.options
      })
      .catch((error) => {
        if (typeof error.response !== 'undefined' && error.response.status === 404) {
          this.$store.commit('snackbar/set', 'このクイズ大会は存在しません。')
        } else {
          console.log(error.response)
          this.$store.commit('snackbar/set', 'エラーが発生しました。')
        }
        this.$router.replace('/')
      })
  },
  methods: {
    close () {
      this.$axios.delete(`/competitions/${this.$route.params.rid}`)
        .then((res) => {
          this.$store.commit('snackbar/set', 'クイズ大会を終了しました。')
          this.$router.replace('/')
        })
        .catch((error) => {
          console.log(error.response)
          this.$store.commit('snackbar/set', 'エラーが発生しました。')
        })
    }
  }
}
</script>