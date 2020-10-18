<template>
  <v-app light>
    <v-app-bar fixed app>
      <v-toolbar-title v-text="title" />
    </v-app-bar>

    <v-main>
      <v-container>
        <nuxt />
      </v-container>
    </v-main>

    <v-footer absolute app>
      <span>&copy; 2020</span>
    </v-footer>
  </v-app>
</template>

<script>
const DEFAULT_TITLE = 'クイズ大会アプリ';

export default {
  data() {
    return {
      title: DEFAULT_TITLE
    }
  },
  created() {
    this.setListener();
  },
  methods: {
    setListener() {
      this.$nuxt.$on('setTitle', (title) => {
        this.title = title || DEFAULT_TITLE
      });
    },
  }
}
</script>
