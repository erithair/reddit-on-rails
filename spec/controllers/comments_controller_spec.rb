require 'rails_helper'

RSpec.describe CommentsController, :type => :controller do
  shared_examples_for 'public access' do
    describe "GET #index" do
      it "assigns links to @links" do
        link = create(:link)
        comment1 = create(:comment, link: link)
        comment2 = create(:comment, link: link)
        get :index, link_id: link
        expect(assigns(:comments)).to match_array([comment1, comment2])
        expect(response).to render_template 'links/index'
      end
    end
  end

  shared_examples_for 'logged-in access' do
    describe "GET #new" do
      it "returns http success" do
        get :new, link_id: @link
        expect(response).to have_http_status(:success)
        expect(response).to render_template :new
      end
    end

    describe "POST #create" do
      it "creates a new comment" do
        expect {
          post :create, link_id: @link, comment: attributes_for(:comment, user: @user, link: @link)
        }.to change(@user.links, :count).by(1)
        expect(response).to redirect_to links_path
      end
    end

    describe "DELETE #destroy" do
      it "delete the comment" do
        comment = create(:comment, user: @user, link: @link)
        expect {
          delete :destroy, id: comment, link_id: @link
        }.to change(@user.links, :count).by(-1)
        expect(response).to redirect_to links_path
      end

      it "can not delete other user's link" do
        comment = create(:comment, link: @link)
        expect {
          delete :destroy, id: comment, link_id: @link
        }.to_not change(Comment, :count)
        expect(response).to redirect_to links_path
      end
    end
  end

  describe "public user" do
    before :each do
      @link = create(:link)
    end

    it_behaves_like 'public access'

    describe "GET #new" do
      it "requires login" do
        get :new, link_id: @link
        expect(response).to require_login
      end
    end

    describe "POST #create" do
      it "requires login" do
        expect {
          post :create, link_id: @link, comment: attributes_for(:comment, link: @link)
        }.to_not change(Comment, :count)
        expect(response).to require_login
      end
    end

    describe "DELETE #destroy" do
      it "requires login" do
        comment = create(:comment, link: @link)
        expect {
          delete :destroy, id: comment, link_id: @link
        }.to_not change(Comment, :count)
        expect(response).to require_login
      end
    end
  end

  describe "logged-in user" do
    before :each do
      @user = create(:user)
      set_user_session @user
    end

    it_behaves_like 'public access'
    it_behaves_like 'logged-in access'
  end
end
