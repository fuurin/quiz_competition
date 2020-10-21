const getDefaultState = () => {
  return {
    email: '',
    auth: {},
  }
}
export const state = getDefaultState;

export const actions = {
  async signIn({commit}, auth) {
    try {
      // 認証
      const res = await this.$axios.post('/auth/sign_in', {
        email: auth.email,
        password: auth.password
      });
      
      // Cookie(Session)にログイン時データを格納
      commit('session', {
        email: res.data.data.email,
        auth: {
          accessToken: res.headers['access-token'],
          client: res.headers['client'],
          uid: res.headers['uid']
        }
      });
      this.$cookies.set('admin-session', this.state.auth, {
        path: '/',
        maxAge: res.headers['expiry'] - Math.floor(Date.now() / 1000)
      });
      alert('ログインしました。');

      // 管理画面トップを表示
      this.$router.replace('/')
    } catch(error) {
      if (typeof error.response !== 'undefined' && error.response.status === 401) {
        alert('メールアドレスかパスワードが間違っています。');
      } else {
        console.log(error);
        alert('エラーが発生しました。');
      }
    }
  },
  verifyLogin({commit}) {
    const session = this.$cookies.get('admin-session');
    if (session) {
      commit('session', session);
      if ($nuxt.$route.path === '/sign_in') {
        alert('すでにログインしています。');
        this.$router.replace('/');
      }
    } else if($nuxt.$route.path !== '/sign_in') {
      alert('ログインして下さい。');
      this.$router.replace('/sign_in');
    }
  },
  signOut({commit}) {
    this.$cookies.remove('admin-session');
    commit('resetState');
    alert('ログアウトしました。');
    this.$router.replace('/sign_in');
  }
}

export const mutations = {
  session(state, session) {
    state.email = session.email;
    state.auth = session.auth;
  },
  resetState (state) {
    Object.assign(state, getDefaultState);
  }
}
