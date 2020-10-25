<template>
  <div>
    <v-container class="d-flex justify-space-between" align-center>
      <h1>クイズ集一覧</h1>
      <v-btn @click="sign_out">ログアウト</v-btn>
    </v-container>

    <v-container>
      <v-card class="px-3">
        <v-list>
          <div v-for="(quiz_set, i) in quiz_sets" :key="i">
            <v-divider v-if="i>0" class="my-2"></v-divider>
            <v-list-item>
              <v-list-item-icon>
                <v-icon v-text="'mdi-head-question-outline'"></v-icon>
              </v-list-item-icon>
              <v-list-item-content>
                <v-list-item-title v-text="quiz_set.title"></v-list-item-title>
              </v-list-item-content>
              <v-btn :to="{ name: 'quiz-sets-id', params: { id: quiz_set.id } }">
                <v-icon>mdi-pencil</v-icon>
              </v-btn>
              <v-btn class="ml-3" @click="select_quiz_set(quiz_set)">
                <v-icon>mdi-account-group</v-icon>
              </v-btn>
            </v-list-item>
          </div>
        </v-list>
      </v-card>
    </v-container>

    <v-dialog v-model="dialog"
      max-width="500"
      @click:outside="unselect_quiz_set" 
      @keydown.enter="start_competition">
      <v-card v-if="selected_quiz_set">
        <v-card-title class="headline">
          クイズ大会「{{ selected_quiz_set.title }}」を開始しますか？
        </v-card-title>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn text @click="unselect_quiz_set">いいえ</v-btn>
          <v-btn color="green darken-1" text @click="start_competition">はい</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
const PAGE_TITLE = 'クイズ大会アプリ 管理画面'

export default {
  data () {
    return {
      quiz_sets: [],
      selected_quiz_set: null,
      dialog: false,
    }
  },
  created() {
    this.$store.commit('page_title', PAGE_TITLE)
    this.$axios.get('/quiz_sets')
      .then((res) => {
        this.quiz_sets = res.data
      })
  },
  methods: {
    sign_out () {
      this.$store.dispatch('auth/sign_out')
    },
    select_quiz_set (quiz_set) {
      this.selected_quiz_set = quiz_set
      this.dialog = true
    },
    unselect_quiz_set () {
      this.selected_quiz_set = null
      this.dialog = false
    },
    start_competition() {
      this.$axios.post('/competitions', { quiz_set_id: this.selected_quiz_set.id })
        .then((res) => {
          if (res.status == 200) {
            this.$store.commit('snackbar/set', 'すでに開始されています。')
          }
          this.$router.push(`/competitions/${res.data.rid}`)
        })
        .catch((error) => {
          console.log(error.response)
          this.$store.commit('snackbar/set', 'エラーが発生しました。')
        })
        .finally(() => { this.dialog = false })
    }
  }
}
</script>