export default ({ app, store, route }) => {
  const session = app.$cookies.get(store.state.auth.SESSION_KEY)

  if (session && (route.name === 'sign_in' || route.name === 'sign_up-rid')) {
    alert('既にログインしています。')
    window.location.href = '/competitions'
    return new Promise(() => {})
  }

  if(!session && route.path === '/competitions') {
    alert('ログインして下さい。')
    window.location.href = '/sign_in'
    return new Promise(() => {})
  }
}
