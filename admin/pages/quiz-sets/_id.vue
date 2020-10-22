<template>
  <div>
    <v-container>
      <h2>{{ quiz_set.name }} の編集</h2>
    </v-container>
    <v-btn @click="save_and_back">
      保存して戻る
    </v-btn>
  </div>
</template>

<script>
const PAGE_TITLE = 'クイズ集の編集';

export default {
  head() {
    return { title: PAGE_TITLE };
  },
  validate({ params }) {
    // 数値でなければならない
    return /^\d+$/.test(params.id)
  },
  data () {
    return {
      quiz_set: {}
    }
  },
  created() {
    this.$store.commit('page_title', PAGE_TITLE);
    this.$axios.get(`/quiz_sets/${this.$route.params.id}`)
      .then((res) => {
        this.quiz_set = res.data.quiz_set;
      });
  },
  methods: {
    save_and_back() {
      this.$store.commit('snackbar/set', '保存しました');
      this.$router.go(-1);
    }
  }
}
</script>