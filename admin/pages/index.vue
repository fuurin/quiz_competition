<template>
  <div>
    <v-container class="d-flex justify-space-between" align-center>
      <h1>クイズ集一覧</h1>
      <v-btn @click="signOut">ログアウト</v-btn>
    </v-container>
    <v-container>
      <v-card class="px-3">
        <v-list>
          <div v-for="(quiz_set, i) in quiz_sets" :key="i">
            <v-divider v-if="i>0"></v-divider>
            <v-list-item>
              <v-list-item-icon>
                <v-icon v-text="'mdi-head-question-outline'"></v-icon>
              </v-list-item-icon>
              <v-list-item-content>
                <v-list-item-title v-text="quiz_set.name"></v-list-item-title>
              </v-list-item-content>
              <v-btn :to="{ name: 'quiz-sets-id', params: { id: quiz_set.id } }">
                <v-icon>mdi-pencil</v-icon>
              </v-btn>
              <v-btn class="ml-3">
                <v-icon>mdi-account-group</v-icon>
              </v-btn>
            </v-list-item>
          </div>
        </v-list>
      </v-card>
    </v-container>
  </div>
</template>

<script>
const PAGE_TITLE = 'クイズ大会アプリ 管理画面';

export default {
  data () {
    return {
      quiz_sets: []
    }
  },
  created() {
    this.$store.commit('page_title', PAGE_TITLE);
    this.$axios.get('/quiz_sets')
      .then((res) => {
        this.quiz_sets = res.data;
      });
  },
  methods: {
    signOut () {
      this.$store.dispatch('auth/signOut');
    }
  }
}
</script>