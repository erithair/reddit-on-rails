require 'rails_helper'

RSpec.describe UsersController, :type => :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    it "creates a new user" do
      expect {
        post :create, user: attributes_for(:user)
      }.to change(User, :count).by(1)
      expect(response).to redirect_to root_path
    end
  end

  describe "GET #show" do
    it "assigns a User to @user" do
      user = create(:user)
      get :show, id: user
      expect(assigns(:user)).to eq user
      expect(response).to render_template :show
    end
  end

  describe "GET #edit" do
    it "assigns a User to @user" do
      user = create(:user)
      get :edit, id: user
      expect(assigns(:user)).to eq user
      expect(response).to render_template :edit
    end
  end

  describe "PATCH #update" do
    before :each do
      @user = create(:user, username: 'Old Name')
    end

    context "with valid attributes" do
      it "updates new data" do
        patch :update, id: @user, user: attributes_for(:user,
          username: 'New Name',
          email: @user.email,
          password: @user.password,
          password_confirmation: @user.password_confirmation)
        @user.reload
        expect(@user.username).to eq 'New Name'
        expect(response).to redirect_to user_path(@user)
      end
    end
    context "with invalid attributes" do
      it "not updates new data" do
        patch :update, id: @user, user: attributes_for(:user,
          username: 'l',
          email: @user.email,
          password: @user.password,
          password_confirmation: @user.password_confirmation)
        @user.reload
        expect(@user.username).to eq 'Old Name'
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    it "delete requested user" do
      user = create(:user)
      expect {
        delete :destroy, id: user
      }.to change(User, :count).by(-1)
      expect(response).to redirect_to root_path
    end
  end

end
