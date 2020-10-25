require 'rails_helper'

RSpec.describe "Admin::Competitions", type: :request do

  describe "GET /show" do
    it "returns http success" do
      get "/admin/competitions/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /next" do
    it "returns http success" do
      get "/admin/competitions/next"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /result" do
    it "returns http success" do
      get "/admin/competitions/result"
      expect(response).to have_http_status(:success)
    end
  end

end
