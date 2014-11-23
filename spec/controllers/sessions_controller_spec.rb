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

    it "redirect to home when already log in" do
      set_user_session(@user)
      get :new
      expect(response).to redirect_to root_path
    end
  end

  describe "POST #create" do
    it "redirect to home when already log in" do
      set_user_session(@user)
      post :create, session: { email: @user.email,
                               password: @user.password,
                               remember_me: '0'}
      expect(response).to redirect_to root_path
    end

    context "log in as inactivated user" do
      it "require activation" do
        user = create(:inactivated_user)
        post :create, session: { email: user.email,
                                 password: user.password,
                                 remember_me: '0'}
        user.reload
        expect(is_logged_in?).to be_falsy
        expect(response).to redirect_to root_path
      end
    end

    context "with valid user info" do
      it "log in, not remember me" do
        post :create, session: { email: @user.email,
                                 password: @user.password,
                                 remember_me: '0'}
        @user.reload
        expect(@user.remember_digest).to be_nil
        expect(session[:user_id]).to eq @user.id
        expect(cookies['remember_token']).to be_nil
        expect(response).to redirect_to user_path(@user)
      end

      it "log in, remember me" do
        post :create, session: { email: @user.email,
                                 password: @user.password,
                                 remember_me: '1'}
        @user.reload
        expect(@user.remember_digest).to_not be_nil
        expect(session[:user_id]).to eq @user.id
        expect(cookies['remember_token']).to_not be_nil
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
      @user.reload
      expect(@user.remember_digest).to be_nil
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to root_path
    end
  end

end
