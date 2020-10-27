<template>
  <v-container class="ma-3">
    <v-container class="d-flex justify-space-between" align-center>
      <h1>
        {{ title }}
        <v-icon @click="copy_link">mdi-clipboard-edit-outline</v-icon>
      </h1>
      <v-btn @click="close_dialog = true">終了</v-btn>
    </v-container>
    <div v-if="status === 'question' || status === 'answer'">
      <v-container>
        <h2>第 {{ quiz.number }} 問 {{ status_name }}（全 {{ total_quiz_num }} 問）</h2>
      </v-container>
      <v-container>
        <v-sheet rounded elevation="2" class="mx-auto pa-4">
          <h3>問題文</h3>
          <p>{{ quiz.text }}</p>
        </v-sheet>
      </v-container>
      <v-container>
        <v-card elevation="2" class="px-3">
          <v-list>
            <div v-for="(option, i) in options" :key="i">
              <v-divider v-if="i>0" class="my-2"></v-divider>
              <v-list-item>
                <v-list-item-icon>
                  <v-icon v-if="option.is_correct_answer">mdi-circle-outline</v-icon>
                  <v-icon v-if="!option.is_correct_answer">mdi-close-thick</v-icon>
                </v-list-item-icon>
                <v-list-item-content>
                  <v-list-item-title v-text="option.text"></v-list-item-title>
                </v-list-item-content>
              </v-list-item>
            </div>
          </v-list>
        </v-card>
      </v-container>
    </div>
    <div v-if="status === 'result'">
      <v-container>
        <h2> {{ status_name }}（全 {{ total_quiz_num }} 問）</h2>
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
              <tr :class="rank_class(item.rank)">
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
      <v-btn @click="next_dialog = true">{{ next_button_label }}</v-btn>
    </v-container>

    <v-dialog v-model="next_dialog"
      max-width="500"
      @click:outside="next_dialog = false" 
      @keydown.enter="next">
      <v-card>
        <v-card-title class="headline">
          {{ status === 'result' ? '最初の問題に戻りますか？' : next_button_label + '進みますか？'}}
        </v-card-title>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn text @click="next_dialog = false">いいえ</v-btn>
          <v-btn color="green darken-1" text @click="next">はい</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-dialog v-model="close_dialog"
      max-width="500"
      @click:outside="close_dialog = false" 
      @keydown.enter="close">
      <v-card>
        <v-card-title class="headline">
          クイズ大会を終了しますか？
        </v-card-title>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn text @click="close_dialog = false">いいえ</v-btn>
          <v-btn color="green darken-1" text @click="close">はい</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-container>
</template>

<script>
const PAGE_TITLE = "クイズ大会 運営画面"

export default {
  head() {
    return { title: PAGE_TITLE }
  },
  validate({ params }) {
    return params.rid.length === 24
  },
  data () {
    return {
      status: null,
      title: '',
      total_quiz_num: 0,
      quiz: {},
      options: [],
      close_dialog: false,
      next_dialog: false,
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
  created() {
    this.$store.commit('page_title', PAGE_TITLE)
    this.fetch()
  },
  methods: {
    copy_link() {
      this.$copyText(`${process.env.service_url || 'http://localhost:8000'}/sign_up/${this.$route.params.rid}`)
      this.$store.commit('snackbar/set', 'クイズ大会へのリンクをコピーしました')
    },
    fetch(method = 'GET') {
      this.$axios({ method: method, url: `/competitions/${this.$route.params.rid}`})
        .then((res) => {
          this.status = res.data.status
          this.title = res.data.title
          this.total_quiz_num = res.data.total_quiz_num
          if (this.status === 'question' || this.status === 'answer') {
            this.quiz = JSON.parse(res.data.quiz)
            this.options = JSON.parse(res.data.options)
          } else if (this.status === 'result' && this.result_items.length === 0) {
            Array.from({length: this.total_quiz_num}, (_,x) => {
              this.result_headers.push({ text: `第${x+1}問`, value: `q${x+1}`})
            })
            this.result_items = JSON.parse(res.data.result)
          }
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
    next() {
      this.fetch('PUT')
      this.next_dialog = false
    },
    close() {
      this.$axios.delete(`/competitions/${this.$route.params.rid}`)
        .then((res) => {
          this.$store.commit('snackbar/set', 'クイズ大会を終了しました。')
          this.$router.replace('/')
        })
        .catch((error) => {
          console.log(error.response)
          this.$store.commit('snackbar/set', 'エラーが発生しました。')
          this.close_dialog = false
        })
    },
    rank_class(rank) {
      switch (rank) {
        case 1: return 'rank-first'
        case 2: return 'rank-second'
        case 3: return 'rank-third'
        default: return ''
      }
    }
  },
  computed: {
    status_name() {
      switch (this.status) {
        case 'question': return '出題中'
        case 'answer': return '正解発表中'
        case 'result': return '結果発表中'
        default: return ''
      }
    },
    next_button_label() {
      switch (this.status) {
        case 'question': return '正解発表へ'
        case 'answer':
          if(this.quiz.number === this.total_quiz_num) return '結果発表へ'
          else return '次の問題へ'
        case 'result': return '最初の問題に戻る'
        default: return ''
      }
    },
  }
}
</script>

<style scoped>
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