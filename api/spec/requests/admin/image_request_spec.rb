require 'rails_helper'

RSpec.describe "Admin::Image", type: :request do

  describe "GET upload_url" do
    it "returns http success" do
      get "/admin/image/upload_url"
      expect(response).to have_http_status(:success)
    end
  end

end
