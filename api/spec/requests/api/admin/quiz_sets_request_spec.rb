require 'rails_helper'

RSpec.describe "Api::Admin::QuizSets", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/api/admin/quiz_sets/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/api/admin/quiz_sets/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/api/admin/quiz_sets/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/api/admin/quiz_sets/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/api/admin/quiz_sets/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
