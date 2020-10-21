export default function ({ app, store, route }) {
  if (app.$cookies.get(store.state.auth.SESSION_KEY)) {
    if (route.path === '/sign_in') {
      alert('既にログインしています。');
      window.location.href = '/'
      return new Promise(() => {});
    }
  } else if(route.path !== '/sign_in') {
    alert('ログインして下さい。');
    window.location.href = '/sign_in';
    return new Promise(() => {});
  }
}
