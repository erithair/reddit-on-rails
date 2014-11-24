require 'rails_helper'

RSpec.describe CommentsController, :type => :controller do
  shared_examples_for 'public access' do
    describe "GET #index" do
      it "assigns comments to @comments" do
        pending "something wrong..."
        link = create(:link)
        comment1 = create(:comment, link: link)
        comment2 = create(:comment, link: link)
        get :index, link_id: link
        expect(response).to redirect_to link
        expect(assigns(:comments)).to match_array([comment1, comment2])
      end
    end
  end

  shared_examples_for 'logged-in access' do
    describe "POST #create" do
      it "creates a new comment" do
        expect {
          post :create, link_id: @link, comment: attributes_for(:comment, user: @user, link: @link)
        }.to change(Comment, :count).by(1)
        expect(response).to redirect_to @link
      end
    end

    describe "DELETE #destroy" do
      it "delete the comment" do
        pending "something wrong..."
        comment = create(:comment, user: @user, link: @link)
        expect {
          delete :destroy, id: comment, link_id: @link
        }.to change(Comment, :count).by(-1)
        expect(response).to redirect_to @link
      end

      it "can not delete other user's comments" do
        comment = create(:comment, link: @link)
        expect {
          delete :destroy, id: comment, link_id: @link
        }.to_not change(Comment, :count)
        expect(response).to redirect_to @link
      end
    end

    describe "POST #vote" do
      it "vote for a comment" do
        comment = create(:comment, link: @link)
        expect {
          post :vote, id: comment, link_id: @link, up: '1'
        }.to change(Vote, :count).by(1)
        expect(comment.rank).to eq 1
        expect(response).to redirect_to @link
      end

      it "can't vote for a link more than once" do
        comment = create(:comment)
        create(:comment_vote, user: @user, votable: comment)
        expect {
          post :vote, id: comment, link_id: @link, up: '1'
        }.to_not change(Vote, :count)
      end
    end
  end

  describe "public user" do
    before :each do
      @link = create(:link)
    end

    it_behaves_like 'public access'

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

    describe "POST #vote" do
      it "requires login" do
        comment = create(:comment)
        expect {
          post :vote, id: comment, link_id: comment.link, up: '1'
        }.to_not change(Vote, :count)
        expect(response).to require_login
      end
    end
  end

  describe "logged-in user" do
    before :each do
      @user = create(:user)
      @link = create(:link)
      set_user_session @user
    end

    it_behaves_like 'public access'
    it_behaves_like 'logged-in access'
  end
end
