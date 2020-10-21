<template>
  <v-app light>
    <v-app-bar fixed app>
      <v-toolbar-title v-text="title" />
    </v-app-bar>

    <v-main>
      <v-container>
        <transition name="page">
          <nuxt />
        </transition>
      </v-container>
    </v-main>

    <v-footer absolute app>
      <span>&copy; 2020</span>
    </v-footer>
  </v-app>
</template>

<script>
const DEFAULT_PAGE_TITLE = 'クイズ大会アプリ 管理画面';

export default {
  head() {
    return { title: '管理画面' };
  },
  data() {
    return {
      title: DEFAULT_PAGE_TITLE,
    }
  },
  created() {
    this.$store.dispatch('auth/verifyLogin');
    this.setListener();
  },
  methods: {
    setListener() {
      this.$nuxt.$on('setTitle', (title) => {
        this.title = title || DEFAULT_PAGE_TITLE;
      });
    },
  }
}
</script>
