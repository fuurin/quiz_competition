<template>
  <div>
    <v-snackbar 
      v-model="is_active" 
      :timeout="$store.state.snackbar.timeout" 
      transition="scroll-y-reverse-transition" 
      :top="true">
      {{ $store.state.snackbar.text }}
    </v-snackbar>
  </div>
</template>

<script>
  export default {
    data () {
      return {
        is_active: false,
      }
    },
    mounted() {
      this.$store.subscribe((mutation, state) => {
        if(mutation.type === 'snackbar/set') {
          this.is_active = true
        }
      })
    },
  }
</script>