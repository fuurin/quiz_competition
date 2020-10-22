<template>
  <div>
    <h1>クイズ大会アプリ 管理画面へようこそ！</h1>
    <v-container>
      <h2>E-mail: {{ $store.state.auth.data.email }}</h2>
      <v-btn class="mt-3" @click="signOut">ログアウト</v-btn>
    </v-container>
    <v-container>
      <v-card class="mx-auto" tile>
        <v-list>
          <v-toolbar-title class="ml-3">クイズ集一覧</v-toolbar-title>
          <v-list-item-group>
            <div v-for="(quiz_set, i) in quiz_sets" :key="i">
              <nuxt-link tag="span" :to="{ name: 'quiz-sets-id', params: { id: quiz_set.id } }">
                <v-list-item>
                  <v-list-item-icon>
                    <v-icon v-text="'mdi-head-question-outline'"></v-icon>
                  </v-list-item-icon>
                    <v-list-item-content>
                      <v-list-item-title v-text="quiz_set.name"></v-list-item-title>
                    </v-list-item-content>
                </v-list-item>
              </nuxt-link>
            </div>
          </v-list-item-group>
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