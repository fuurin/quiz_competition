const SESSION_KEY = '_quiz_competition_service_session'

const getDefaultState = () => {
  return {
    SESSION_KEY: SESSION_KEY,
    data: {}
  }
}
export const state = getDefaultState

export const mutations = {
  data(state, data) {
    state.data = data
  },
  resetState (state) {
    Object.assign(state, getDefaultState)
  }
}

export const actions = {
  async authenticate({commit}, auth) {
    try {
      // 認証
      const res = await this.$axios.post(`/auth/${auth.action}`, auth.params)

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
      })

      // ログイン対象のデータをstore
      commit('data', res.data.data)

      commit('snackbar/set', 'ログインしました', { root: true })

      // クイズ大会ページへ遷移
      this.$router.replace('/competitions')
    } catch(error) {
      if (typeof error.response !== 'undefined' && error.response.status === 401) {
        commit('snackbar/set', 'メールアドレスかパスワードが間違っています。', { root: true })
      } else {
        console.log(error.response)
        commit('snackbar/set', 'エラーが発生しました。', { root: true })
      }
    }
  },
  async sign_out({commit}) {
    await this.$axios.delete('/auth/sign_out')
    this.$cookies.remove(SESSION_KEY)
    commit('resetState')
    commit('snackbar/set', 'ログアウトしました。', { root: true })
    this.$router.replace('/sign_in')
  }
}
