require 'rails_helper'

RSpec.describe PagesController, :type => :controller do
  describe "GET #home" do
    it "returns http success" do
      get :home
      expect(response).to have_http_status(:success)
      expect(response).to render_template :home
    end
  end
end
