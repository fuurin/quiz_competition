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
        <h2>
          {{ answer_result }}
        </h2>
      </v-container>
      <v-container>
        <v-sheet rounded elevation="2" class="mx-auto pa-4">
          <p>{{ quiz.text }}</p>
          <v-img :src="image_url" v-if="image_url" class="mb-2"
            max-width="640" max-height="360" contain>
          </v-img>
        </v-sheet>
      </v-container>
      <v-container>
        <v-card elevation="2" class="px-3">
          <v-list>
            <v-radio-group v-model="answer" class="mt-2" :disabled="status !== 'question'">
              <div v-for="(option, i) in options" :key="i">
                <v-divider v-if="i>0" class="my-5"></v-divider>
                <v-list-item>
                  <v-list-item-content 
                    :class="
                      ((option.id === selected_answer) ? 'selected-answer ' : ' ') +
                      (option.is_correct_answer ? 'correct-answer ' : ' ')
                    ">
                    <v-radio :label="option.text" :value="option.id" class="ml-2"></v-radio>
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
        <h2>お疲れさまでした！</h2>
      </v-container>
      <v-container>
        <v-sheet rounded elevation="2" class="mx-auto pa-4">
          <v-card-title>
            クイズ大会の結果
            <v-spacer></v-spacer>
            <v-text-field
              v-model="result_search"
              append-icon="mdi-magnify"
              label="検索"
              single-line
              hide-details>
            </v-text-field>
          </v-card-title>
          <v-data-table 
            :headers="result_headers"
            :hide-default-header="true"
            :items="result_items"
            :search="result_search">
            <template v-slot:header="{ props: { headers } }">
              <thead>
                <tr>
                  <th v-for="(header, i) in headers" :key="i" class="text-start text-no-wrap">
                    {{ header.text }}
                  </th>
                </tr>
              </thead>
            </template>
            <template v-slot:item="{ item }">
              <tr :class="row_color(item)">
                <td v-for="(header, i) in result_headers" :key="i" class="text-start text-no-wrap">
                  {{ item[header.value] }}
                </td>
              </tr>
            </template>
          </v-data-table>
        </v-sheet>
      </v-container>
    </div>
    <v-container>
      <v-btn
        v-if="status === 'question'"
        @click="send_answer">
        回答を送信
      </v-btn> 
      <v-btn 
        v-if="!(status === 'question' && selected_answer === null)"
        @click="next"
        class="ml-3">
        {{ next_button_label }}
      </v-btn>
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
      answer: null,
      selected_answer: null,
      image_url: null,
      sign_out_dialog: false,
      result_headers: [
        { text: '順位', value: 'rank' },
        { text: '正解数', value: 'correct_num' },
        { text: '名前', value: 'name' },
        { text: 'email', value: 'email' }
      ],
      result_items: [],
      result_search: '',
    }
  },
  async created() {
    await this.fetch_info()
  },
  methods: {
    async fetch_info() {
      return await this.$axios.get('/competitions')
        .then((res) => {
          this.user_name = res.data.user_name
          this.status = res.data.status
          this.title = res.data.title
          this.$store.commit('page_title', this.title)
          this.total_quiz_num = res.data.total_quiz_num
          if (this.status === 'question' || this.status === 'answer') {
            this.quiz = JSON.parse(res.data.quiz)
            this.options = JSON.parse(res.data.options)
            this.answer = res.data.answer
            this.selected_answer = this.answer
            this.image_url = res.data.image_url
          } else if (this.status === 'result' && this.result_items.length === 0) {
            Array.from({length: this.total_quiz_num}, (_,x) => {
              this.result_headers.push({ text: `第${x+1}問`, value: `q${x+1}`})
            })
            this.result_items = JSON.parse(res.data.result)
          }
          return true
        })
        .catch((error) => {
          if (typeof error.response !== 'undefined' && error.response.status === 404) {
            this.$store.commit('snackbar/set', 'このクイズ大会は存在しません。')
          } else if (error.response.status === 401) {
            this.$store.commit('snackbar/set', 'このクイズ大会は終了しました。')
          } else {
            console.log(error.response)
            this.$store.commit('snackbar/set', 'エラーが発生しました。')
          }
          this.$cookies.remove(this.$store.state.auth.SESSION_KEY)
          this.$router.replace('/')
          return false
        })
        .finally(() => { this.next_dialog = false })
    },
    async next() {
      const current_status = this.status
      const current_quiz_number = this.quiz.number
      if (!(await this.fetch_info())) return
      if (this.status !== 'result' && current_status === this.status && current_quiz_number === this.quiz.number) {
        this.$store.commit('snackbar/set', 'クイズ大会が進行するまでお待ちください。')
      }
    },
    send_answer() {
      if(this.answer === null) {
        this.$store.commit('snackbar/set', '回答を選択してください。')
        return
      }
      if(this.answer === this.selected_answer) {
        this.$store.commit('snackbar/set', '同じ回答です。')
        return
      }
      this.$axios.post('/answers', { option_id: this.answer })
        .then((res) => {
          if (res.status === 200) this.$store.commit('snackbar/set', '回答を上書きしました。')
          if (res.status === 201) this.$store.commit('snackbar/set', '回答を送信しました。')
          this.selected_answer = this.answer
        }).catch((error) => {
          if (error.response.status === 405) {
            this.$store.commit('snackbar/set', this.selected_answer !== null ? '正解発表をご覧ください。' : '時間切れです。')
            this.fetch_info()
          } else if(error.response.status === 401) {
            this.$store.commit('snackbar/set', 'このクイズ大会は終了しました。')
            this.$cookies.remove(this.$store.state.auth.SESSION_KEY)
            this.$router.replace('/')
          } else {
            console.log(error.response)
            this.$store.commit('snackbar/set', 'エラーが発生しました。')
          }
        })
        .finally(() => { this.next_dialog = false })
    },
    sign_out() {
      this.$store.dispatch('auth/sign_out')
      this.sign_out_dialog = false
    },
    row_color(item) {
      if (this.$store.state.auth.data.email === item.email) return 'self-row'
      switch (item.rank) {
        case 1: return 'rank-first'
        case 2: return 'rank-second'
        case 3: return 'rank-third'
        default: return ''
      }
    }
  },
  computed: {
    answer_result() {
      if (this.status !== 'answer') return
      for(var i in this.options) {
        if (this.options[i].is_correct_answer && this.options[i].id === this.selected_answer) {
          return '正解です！'
        }
      }
      return '不正解です...'
    },
    next_button_label() {
      switch (this.status) {
        case 'question': return '正解を確認'
        case 'answer':
          if(this.quiz.number === this.total_quiz_num) return '結果発表へ'
          else return '次の問題へ'
        case 'result': return '更新'
        default: return ''
      }
    },
  },
}
</script>

<style scoped>
  .selected-answer {
    background-color: gold;
  }

  .correct-answer {
    background-color: chartreuse;
  }

  .self-row {
    background-color: chartreuse
  }

  .rank-first {
    background-color: gold;
  }

  .rank-second {
    background-color: lightsteelblue;
  }

  .rank-third {
    background-color: lightsalmon;
  }
</style>