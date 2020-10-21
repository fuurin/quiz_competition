<template>
  <v-app light>
    <v-app-bar fixed app>
      <v-toolbar-title v-text="$store.state.page_title" />
    </v-app-bar>

    <Snackbar />

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
export default {
}
</script>
