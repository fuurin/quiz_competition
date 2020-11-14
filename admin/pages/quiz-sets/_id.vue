<template>
  <v-container class="ma-3">
    <transition-group name="list">
      <div v-for="(quiz, i) in quizzes" :key="quiz.number">
        <v-card class="my-4 px-1" outlined shaped elevation=2>
          <div class="d-flex justify-space-between" align-center>
            <div class="d-flex justify-start">
              <v-card-title>第 {{ i + 1 }} 問</v-card-title>
              <v-icon v-if="i>0" @click="up(i)">mdi-arrow-up-bold</v-icon>
              <v-icon v-if="i < quizzes.length - 1" @click="down(i)" class="ml-1">mdi-arrow-down-bold</v-icon>
            </div>
            <div class="mt-5 mr-4">
              <v-icon 
                v-if="quizzes.length > 1"
                @click="delete_quiz(i)">
                mdi-close</v-icon>
            </div>
          </div>
          <v-container class="px-4 py-0">
            <v-textarea
              v-model="quiz.text" 
              label="問題文" 
              placeholder="例：パンはパンでも食べられないパンはなーんだ？" 
              rows="2" 
              outlined>
            </v-textarea>
            <v-card-subtitle class="pl-4 pt-0">▼ 正解ならチェック(最低1個)</v-card-subtitle>
            <div v-for="(option, j) in quiz.options" :key="j">
              <v-row align-center>
                <v-checkbox
                  v-model="option.is_correct_answer"
                  class="ml-6 mr-4">
                </v-checkbox>
                <v-text-field
                  v-model="option.text"
                  :label="`選択肢${j + 1}`"
                  placeholder="例：メロンパン"
                  outlined
                  class="mr-2">
                </v-text-field>
                <div class="mr-3">
                  <v-icon 
                    v-if="quiz.options.length > 2" 
                    @click="delete_option(quiz, j)">
                    mdi-close</v-icon>
                </div>
              </v-row>
            </div>
            <v-container class="pt-0">
              <v-btn @click="add_option(quiz)">
                <v-icon>mdi-plus-thick</v-icon>
              </v-btn>
            </v-container>
            <v-container>
              <v-file-input
                accept="image/*"
                label="問題用画像"
                outlined
                prepend-icon="mdi-file-image"
                :value="quiz.image_file"
                @change="change_image($event, quiz)"
              ></v-file-input>
              <v-img :src="quiz.image_url" 
                    v-if="quiz.image_url"
                    max-width="360" max-height="640" contain
                    class="ml-8 mb-8"></v-img>
              <v-file-input
                accept="image/*"
                label="正解用画像"
                outlined
                prepend-icon="mdi-file-image-outline"
                :value="quiz.answer_image_file"
                @change="change_image($event, quiz, for_answer=true)"
              ></v-file-input>
              <v-img :src="quiz.answer_image_url" 
                    v-if="quiz.answer_image_url"
                    max-width="360" max-height="640" contain
                    class="ml-8 mb-8"></v-img>
            </v-container>
          </v-container>
        </v-card>
      </div>
    </transition-group>
    <v-container>
      <v-btn @click="add_quiz">
        <v-icon>mdi-plus-thick</v-icon>
      </v-btn>
    </v-container>
    <v-container>
      <v-btn @click="save">
        保存
      </v-btn>
      <v-btn @click="save_and_back" class="ml-4">
        保存して戻る
      </v-btn>
    </v-container>
  </v-container>
</template>

<script>

function empty_option(number = 1) {
  return  {
    number: number,
    text: "",
    is_correct_answer: false
  }
}

function empty_quiz(number = 1) {
  return {
    number: number,
    text: "",
    options: [1,2,3].map((i) => {
      const option = empty_option(i)
      option.is_correct_answer = (i % 2 == 0)
      return option
    }),
    image_url: "",
    image_file: null,
    answer_image_url: "",
    answer_image_file: null
  }
}

function image_key_to_empty_file(key) {
  const file_name = key.split("/").pop().split("_").splice(2).join("_")
  const file_type = `image/${file_name.split(".").pop()}`
  return new File([""], file_name, { type: file_type })
}

export default {
  head() {
    return { title: 'クイズ集の編集' }
  },
  validate({ params }) {
    // 数値でなければならない
    return /^\d+$/.test(params.id)
  },
  data () {
    return {
      quiz_set: { id: 0, title: "" },
      quizzes: []
    }
  },
  created() {
    this.$axios.get(`/quiz_sets/${this.$route.params.id}`)
      .then((res) => {
        this.quiz_set = res.data.quiz_set
        this.$store.commit('page_title', this.quiz_set.title + ' の編集')
        this.quizzes = res.data.quizzes.map((q) => {
          var quiz = empty_quiz(q.number)
          quiz.text = q.text
          quiz.options = q.options.map((o) => {
            var option = empty_option(o.number)
            option.text = o.text
            option.is_correct_answer = o.is_correct_answer
            return option
          })
          if (typeof(q.image_key) !== 'undefined' && q.image_key !== '') {
            quiz.image_url = res.data.image_base_url + q.image_key
            quiz.image_file = image_key_to_empty_file(q.image_key)
          }
          if (typeof(q.answer_image) !== 'undefined' && q.answer_image !== '') {
            quiz.answer_image_url = res.data.image_base_url + q.answer_image_key
            quiz.answer_image_file = image_key_to_empty_file(q.answer_image_key)
          }
          return quiz
        })
        if(this.quizzes.length === 0) this.add_quiz()
      })
      .catch((error) => {
        if (typeof error.response !== 'undefined' && error.response.status === 404) {
          this.$store.commit('snackbar/set', 'このクイズ集は存在しません。')
        } else {
          console.log(error.response)
          this.$store.commit('snackbar/set', 'エラーが発生しました。')
        }
        this.$router.replace('/')
      })
  },
  methods: {
    add_quiz() {
      this.quizzes.push(empty_quiz(this.quizzes.length + 1))
    },
    add_option(quiz) {
      quiz.options.push(empty_option(quiz.options.length + 1))
    },
    up(i) {
      this.quizzes[i].number = i
      this.quizzes[i-1].number = i + 1
      this.quizzes.splice(i-1, 2, this.quizzes[i], this.quizzes[i-1])
    },
    down(i) {
      this.quizzes[i].number = i + 2
      this.quizzes[i+1].number = i + 1
      this.quizzes.splice(i, 2, this.quizzes[i+1], this.quizzes[i])
    },
    delete_quiz(i) {
      this.quizzes.splice(i, 1)
      for (var x=i; x<this.quizzes.length; x++) {
        this.quizzes[x].number--
      }
    },
    delete_option(quiz, i) {
      quiz.options.splice(i, 1)
      for (var x=i; x<quiz.options.length; x++) {
        quiz.options[x].number--
      }
    },
    async change_image(file, quiz, for_answer = false) {
      if (typeof file === 'undefined') {
        quiz[for_answer ? 'answer_image' : 'image'] = ''
        return
      }
      this.$axios.get('/image/upload_url', { params: {
        file_name: file.name,
        file_type: file.type,
        file_size: file.size,
        quiz_set_id: this.quiz_set.id,
        previous_file_url: for_answer ? quiz.answer_image_url : quiz.image_url
      } } )
        .then(async (res) => { 
          await this.$axios.put(res.data.upload_url, file)
            .catch((error) => { this.$store.commit('snackbar/set', error.message) })
          await this.$axios.put('/image/temporalize', { key: res.data.key })
            .catch((error) => { this.$store.commit('snackbar/set', error.message) })
          quiz[for_answer ? 'answer_image_url' : 'image_url'] = res.data.url
          quiz[for_answer ? 'answer_image_file' : 'image_file'] = file
        })
        .catch((error) => { this.$store.commit('snackbar/set', error.message) })
    },
    async save() {
      this.$store.commit('snackbar/set', '保存中...')
      return await this.$axios.post('/quizzes', {
        quiz_set_id: this.quiz_set.id,
        quizzes: this.quizzes.map((quiz) => {
          return {
            number: quiz.number,
            text: quiz.text,
            options: quiz.options,
            image_url: quiz.image_url,
            answer_image_url: quiz.answer_image_url,
          }
        })
      }).then(() => {
        this.$store.commit('snackbar/set', '保存しました。')
        return true
      }).catch(() => {
        this.$store.commit('snackbar/set', '保存に失敗しました。')
        return false
      })
    },
    async save_and_back() {
      if (await this.save() === true) {
        this.$router.go(-1)
      }
    }
  }
}
</script>