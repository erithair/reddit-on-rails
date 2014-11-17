require 'rails_helper'

RSpec.describe AccountActivationsController, :type => :controller do
  describe "GET #edit" do
    it "should activate the user" do
      user = create(:inactivated_user)
      expect(user.activated?).to be_falsy
      get :edit, id: user.activation_token, email: user.email
      user.reload
      expect(user.activated?).to be_truthy
      expect(response).to redirect_to user
    end
  end
end
