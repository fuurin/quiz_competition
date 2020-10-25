<template>
  <v-container class="ma-3">
    <v-container class="d-flex justify-space-between" align-center>
      <h1>参加者名：{{ user_name }} さん</h1>
      <v-btn @click="sign_out_dialog = true">ログアウト</v-btn>
    </v-container>
    <div v-if="status === 'question' || status === 'answer'">
      <v-container>
        <h2>
          第 {{ quiz.number }} / {{ total_quiz_num }} 問
          <span v-if="status === 'answer'">の答え</span>
        </h2>
      </v-container>
      <v-container>
        <v-sheet rounded elevation="2" class="mx-auto pa-4">
          <p>{{ quiz.text }}</p>
        </v-sheet>
      </v-container>
      <v-container>
        <v-card elevation="2" class="px-3">
          <v-list>
            <v-radio-group v-model="answer" class="mt-2">
              <div v-for="(option, i) in options" :key="i">
                <v-divider v-if="i>0" class="my-5"></v-divider>
                <v-list-item>
                  <v-list-item-content>
                    <v-radio :label="option.text" :value="option.number"></v-radio>
                  </v-list-item-content>
                </v-list-item>
              </div>
            </v-radio-group>
          </v-list>
        </v-card>
      </v-container>
    </div>
    <div v-if="status === 'result'">
      <v-container>
        <h2> 結果発表！（全 {{ total_quiz_num }} 問）</h2>
      </v-container>
      <v-container>
        <v-sheet rounded elevation="2" class="mx-auto pa-4">
          <h3>お疲れさまでした</h3>
        </v-sheet>
      </v-container>
    </div>
    <v-container>
      <v-btn @click="select_answer">{{ next_button_label() }}</v-btn>
    </v-container>

    <v-dialog v-model="sign_out_dialog"
      max-width="500"
      @click:outside="sign_out_dialog = false" 
      @keydown.enter="sign_out">
      <v-card>
        <v-card-title class="headline">
          ログアウトしますか？
        </v-card-title>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn text @click="sign_out_dialog = false">いいえ</v-btn>
          <v-btn color="green darken-1" text @click="sign_out">はい</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-container>
</template>

<script>
export default {
  head() {
    return { title: this.title }
  },
  data () {
    return {
      user_name: '',
      status: '',
      title: '',
      total_quiz_num: 0,
      quiz: {},
      options: [],
      answer: 0,
      selected_answer: 0,
      sign_out_dialog: false,
    }
  },
  created() {
    this.fetch()
  },
  methods: {
    fetch() {
      this.$axios.get('/competitions')
        .then((res) => {
          this.user_name = res.data.user_name
          this.status = res.data.status
          this.title = res.data.title
          this.$store.commit('page_title', this.title)
          this.total_quiz_num = res.data.total_quiz_num
          if (this.status !== 'question' && this.status !== 'answer') return
          this.quiz = JSON.parse(res.data.quiz)
          this.options = JSON.parse(res.data.options)
          this.answer = res.data.answer
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
        .finally(() => { this.next_dialog = false })
    },
    next_button_label() {
      switch (this.status) {
        case 'question': return '回答する'
        case 'answer':
          if(this.quiz.number === this.total_quiz_num) return '結果発表へ'
          else return '次の問題へ'
        case 'result': return '最初の問題に戻る'
        default: return ''
      }
    },
    sign_out() {
      this.$store.dispatch('auth/sign_out')
      this.sign_out_dialog = false
    },
    select_answer() {
      this.selected_answer = this.answer
      console.log(this.selected_answer)
    },
    next() {
      this.fetch()
    }
  }
}
</script>