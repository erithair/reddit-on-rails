require 'rails_helper'

RSpec.describe Links::VotesController, :type => :controller do
  describe "POST #create" do
    context 'when user not log in' do
      it "requires login" do
        link = create(:link)
        expect {
          post :create, link_id: link, up: '1'
        }.to_not change(Vote, :count)
        expect(response).to require_login
      end
    end

    context 'when user logged in' do
      before :each do
        @link = create(:link)
        @user = create(:user)
        set_user_session @user
      end

      it "vote for a link to rise its rank" do
        expect {
          post :create, link_id: @link, up: '1'
        }.to change(Vote, :count).by(1)
        @link.reload
        expect(@link.rank).to eql 1
        expect(response).to redirect_to links_path
      end

      it "can't vote for a link more than once" do
        create(:link_vote, user: @user, votable: @link)
        expect {
          post :create, link_id: @link, up: '1'
        }.to_not change(Vote, :count)
      end
    end
  end
end
