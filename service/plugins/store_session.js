export default ({ store, app }) => {
  const session = app.$cookies.get(store.state.auth.SESSION_KEY)
  if (session) store.commit('auth/data', session.data)
}