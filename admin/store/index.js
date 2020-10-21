const DEFAULT_PAGE_TITLE = 'クイズ大会アプリ 管理画面';

export const state = () => {
  return {
    page_title: DEFAULT_PAGE_TITLE
  }
}

export const mutations = {
  page_title(state, page_title) {
    state.page_title = page_title;
  }
}