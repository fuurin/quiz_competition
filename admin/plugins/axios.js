export default ({ $axios, store, app }) => {
  $axios.onRequest(config => {
    const session = app.$cookies.get(store.state.auth.SESSION_KEY);
    if (session) config.headers = session.auth;
  });

  $axios.onResponse(res => {
    if (
      !res.headers['access-token'] ||
      !res.headers['client'] ||
      !res.headers['uid']
    ) return;

    const session = app.$cookies.get(store.state.auth.SESSION_KEY);
    if(!session) return;
    
    // セッション更新・延長
    session.auth['access-token'] = res.headers['access-token'];
    session.auth['client'] = res.headers['client'];
    session.auth['uid'] = res.headers['uid'];
    app.$cookies.set(store.state.auth.SESSION_KEY, session, {
      path: '/',
      maxAge: res.headers['expiry'] - Math.floor(Date.now() / 1000)
    });
  });
}