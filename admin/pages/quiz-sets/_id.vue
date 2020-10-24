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
              <v-icon @click="delete_quiz(i)">mdi-close</v-icon>
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
            <v-card-subtitle class="pl-4 pt-0">▼ 正解ならチェック</v-card-subtitle>
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
                <div>
                  <v-icon class="mr-3" @click="delete_option(quiz, j)">mdi-close</v-icon>
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
                small-chips
                outlined
                prepend-icon="mdi-file-image"
                @change="preview_image($event, quiz.image)"
              ></v-file-input>
              <v-img :src="quiz.image.url" 
                    v-if="quiz.image.url"
                    max-width="360" max-height="640" contain
                    class="ml-8 mb-8"></v-img>
              <v-file-input
                accept="image/*"
                label="正解用画像"
                small-chips
                outlined
                prepend-icon="mdi-file-image-outline"
                @change="preview_image($event, quiz.answer_image)"
              ></v-file-input>
              <v-img :src="quiz.answer_image.url" 
                    v-if="quiz.answer_image.url"
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
    options: [false,true,false].map((correct) => {
      option = empty_option();
      if(correct) option.is_correct_answer = true;
      return option;
    }),
    image: {
      url: "",
      name: "",
      type: ""
    },
    answer_image: {
      url: "",
      name: "",
      type: ""
    },
    is_edited: true
  }
}

export default {
  head() {
    return { title: 'クイズ集の編集' };
  },
  validate({ params }) {
    // 数値でなければならない
    return /^\d+$/.test(params.id)
  },
  data () {
    return {
      quiz_set: {},
      quizzes: []
    }
  },
  created() {
    this.$axios.get(`/quiz_sets/${this.$route.params.id}`)
      .then((res) => {
        this.quiz_set = res.data.quiz_set;
        console.log(res.data.quizzes);
        this.$store.commit('page_title', this.quiz_set.name + ' の編集');
        if(this.quizzes.length == 0) {
          this.add_quiz();
        }
      });
  },
  methods: {
    add_quiz() {
      this.quizzes.push(empty_quiz(this.quizzes.length + 1))
    },
    add_option(quiz) {
      quiz.options.push(empty_option(quiz.options.length + 1))
    },
    up(i) {
      this.quizzes[i].number = i - 1;
      this.quizzes[i-1].number = i;
      this.quizzes.splice(i-1, 2, this.quizzes[i], this.quizzes[i-1]);
    },
    down(i) {
      this.quizzes[i].number = i + 1;
      this.quizzes[i+1].number = i;
      this.quizzes.splice(i, 2, this.quizzes[i+1], this.quizzes[i]);
    },
    delete_quiz(i) {
      this.quizzes.splice(i, 1)
      for (var x=i; x<this.quizzes.length; x++) {
        this.quizzes[x].number--;
      }
    },
    delete_option(quiz, i) {
      quiz.options.splice(i, 1)
      for (var x=i; x<quiz.options.length; x++) {
        this.quizzes.options[x].number--;
      }
    },
    preview_image(file, image) {
      image.url = file ? window.URL.createObjectURL(file) : ""
      image.name = file ? file.name : ""
      image.type = file ? file.type : ""
    },
    save() {
      this.$store.commit('snackbar/set', '保存しました')
    },
    save_and_back() {
      this.save()
      this.$router.go(-1)
    }
  }
}
</script>