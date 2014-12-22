require 'rails_helper'

RSpec.describe Comments::VotesController, :type => :controller do
  describe "POST #create" do
    context 'when user not log in' do
      it "requires login" do
        comment = create(:comment)
        expect {
          post :create, link_id: comment.link, comment_id: comment, up: '1'
        }.to_not change(Vote, :count)
        expect(response).to require_login
      end
    end

    context 'when user logged in' do
      before :each do
        @comment = create(:comment)
        @user = create(:user)
        set_user_session @user
      end

      it "vote for a comment" do
        expect {
          post :create, link_id: @comment.link, comment_id: @comment, up: '1'
        }.to change(Vote, :count).by(1)
        @comment.reload
        expect(@comment.rank).to eql 1
        expect(response).to redirect_to @comment.link
      end

      it "can't vote for a link more than once" do
        create(:comment_vote, user: @user, votable: @comment)
        expect {
          post :create, link_id: @comment.link, comment_id: @comment, up: '1'
        }.to_not change(Vote, :count)
      end
    end
  end
end
