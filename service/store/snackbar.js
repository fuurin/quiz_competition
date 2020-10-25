const DEFAULT_TIMEOUT = 2000

export const state = () => {
  return {
    text: '',
    timeout: DEFAULT_TIMEOUT
  }
}

export const getters = {
  text(state) { return state.text }
}

export const mutations = {
  set(state, text) {
    state.text = text
  }
}
