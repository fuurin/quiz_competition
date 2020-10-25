<template>
  <v-app light>
    <v-app-bar fixed app color="primary">
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
const DEFAULT_PAGE_TITLE = 'クイズ大会アプリ'

export default {
  data() {
    return {
      title: DEFAULT_PAGE_TITLE
    }
  },
  created() {
    this.setListener()
  },
  methods: {
    setListener() {
      this.$nuxt.$on('setTitle', (title) => {
        this.title = title || DEFAULT_PAGE_TITLE
      })
    },
  }
}
</script>
