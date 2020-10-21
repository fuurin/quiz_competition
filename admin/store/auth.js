const SESSION_KEY = '_quiz_competition_admin_session';

const getDefaultState = () => {
  return {
    SESSION_KEY: SESSION_KEY,
    data: {}
  }
}
export const state = getDefaultState;

export const mutations = {
  data(state, data) {
    state.data = data;
  },
  resetState (state) {
    Object.assign(state, getDefaultState);
  }
}

export const actions = {
  async signIn({commit}, auth) {
    try {
      // 認証
      const res = await this.$axios.post('/auth/sign_in', {
        email: auth.email,
        password: auth.password
      });

      // 認証時セッション作成
      this.$cookies.set(SESSION_KEY, {
        auth: {
          'access-token': res.headers['access-token'],
          'client': res.headers['client'],
          'uid': res.headers['uid']
        },
        data: res.data.data
      }, {
        path: '/',
        maxAge: res.headers['expiry'] - Math.floor(Date.now() / 1000)
      });

      // ログイン対象のデータをstore
      commit('data', res.data.data);

      // トップページへ遷移
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
  async signOut({commit}) {
    await this.$axios.delete('/auth/sign_out');
    this.$cookies.remove(SESSION_KEY);
    commit('resetState');
    alert('ログアウトしました。');
    this.$router.replace('/sign_in');
  }
}
