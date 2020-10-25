require 'rails_helper'

RSpec.describe "Service::Answers", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/service/answers/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/service/answers/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/service/answers/create"
      expect(response).to have_http_status(:success)
    end
  end

end
