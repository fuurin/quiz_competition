export default ({ app, store, route }) => {
  const session = app.$cookies.get(store.state.auth.SESSION_KEY)

  if (session && route.path === '/sign_in') {
    alert('既にログインしています。')
    window.location.href = '/'
    return new Promise(() => {})
  }

  if(!session && route.path !== '/sign_in') {
    alert('ログインして下さい。')
    window.location.href = '/sign_in'
    return new Promise(() => {})
  }
}
