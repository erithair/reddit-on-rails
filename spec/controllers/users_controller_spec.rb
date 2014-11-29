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
      expect(response).to redirect_to links_user_path
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
          password: @user.password,
          password_confirmation: @user.password_confirmation)
        @user.reload
        expect(@user.username).to eq 'New Name'
        expect(response).to redirect_to user_path(@user)
      end
    end
    context "with invalid attributes" do
      it "not updates new data with invalid username" do
        patch :update, id: @user, user: attributes_for(:user,
          username: 'l',
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

  describe "GET #links" do
    before :each do
      @user = create(:user)
      @link1 = create(:link, user: @user)
      @link2 = create(:link, user: @user)
    end

    it "assigns links to @comments" do
      get :links, id: @user
      expect(assigns(:links)).to match_array([@link1, @link2])
    end

    it "sorted by created time desc when specify order: latest" do
      get :links, id: @user, order: 'latest'
      expect(assigns(:links).first).to eq @link2
    end

    it "sorted by votes when specify order: rank" do
      create(:link_vote, votable: @link1, up: 1)

      get :links, id: @user, order: 'rank'
      expect(assigns(:links).first).to eq @link1
    end

    it "sorted by comments count when specify order: hot" do
      create(:comment, link: @link1)

      get :links, id: @user, order: 'hot'
      expect(assigns(:links).first).to eq @link1
    end
  end

  describe "GET #comments" do
    before :each do
      @user = create(:user)
      @comment1 = create(:comment, user: @user)
      @comment2 = create(:comment, user: @user)
    end

    it "assigns comments to @comments" do
      get :comments, id: @user
      expect(assigns(:comments)).to match_array([@comment1, @comment2])
    end

    it "sort by created time desc when not specify the order" do
      get :comments, id: @user
      expect(assigns(:comments).first).to eq @comment2
    end

    it "sort by created time desc when specify order: latest" do
      get :comments, id: @user, order: 'latest'
      expect(assigns(:comments).first).to eq @comment2
    end

    it "sort by votes when specify order: rank" do
      create(:comment_vote, votable: @comment1, up: 1)

      get :comments, id: @user, order: 'rank'
      expect(assigns(:comments).first).to eq @comment1
    end
  end

end
