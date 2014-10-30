require 'rails_helper'

RSpec.describe SessionsController, :type => :controller do
  before :each do
    @user = create(:user)
  end

  describe "GET #new" do
    it "render new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context "with valid user info" do
      it "log in successfully" do
        post :create, session: { email: @user.email, password: @user.password }
        expect(session[:user_id]).to eq @user.id
        expect(response).to redirect_to user_path(@user)
      end
    end

    context "with invalid user info" do
      it "description" do
        post :create, session: { email: 'invalid@example.com', password: 'secret' }
        expect(session[:user_id]).to be_nil
        expect(response).to render_template :new
      end
    end
  end

  describe "delete #destroy" do
    it "logout successfully" do
      set_user_session(@user)

      delete :destroy
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to root_path
    end
  end

end
