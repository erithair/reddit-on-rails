require 'rails_helper'

RSpec.describe ApplicationHelper, :type => :helper do
  describe "#full_title()" do
    before :each do
      @base_title = 'RedditOnRails'
    end

    it "has base title" do
      expect(full_title).to eq @base_title
    end

    it "has full title" do
      expect(full_title('extension')).to eq "extension - #{@base_title}"
    end
  end

  describe "#if_link_active()" do
    it "link is active when it should be" do
      expect(if_link_active(:active, :active)).to eq 'active'
    end

    it "link isn't active when it should not be" do
      expect(if_link_active(:not_active, :active)).to eq ''
    end
  end

  describe "#if_voted()" do
    before :each do
      @user = create(:user)
      @link = create(:link)
      @comment = create(:comment)
    end

    it "user made up votes" do
      create(:link_vote, user: @user, votable: @link, up: 1)
      create(:comment_vote, user: @user, votable: @comment, up: 1)

      expect(if_voted(user: @user, link: @link, up: 1)).to eq 'voted-up voted-disable'
      expect(if_voted(user: @user, link: @link, up: -1)).to eq 'voted-disable'
      expect(if_voted(user: @user, comment: @comment, up: 1)).to eq 'voted-up voted-disable'
      expect(if_voted(user: @user, comment: @comment, up: -1)).to eq 'voted-disable'
    end

    it "user made down votes" do
      create(:link_vote, user: @user, votable: @link, up: -1)
      create(:comment_vote, user: @user, votable: @comment, up: -1)

      expect(if_voted(user: @user, link: @link, up: 1)).to eq 'voted-disable'
      expect(if_voted(user: @user, link: @link, up: -1)).to eq 'voted-down voted-disable'
      expect(if_voted(user: @user, comment: @comment, up: 1)).to eq 'voted-disable'
      expect(if_voted(user: @user, comment: @comment, up: -1)).to eq 'voted-down voted-disable'
    end

    it "user didn't make any vote" do
      expect(if_voted(user: @user, link: @link, up: 1)).to eq ''
      expect(if_voted(user: @user, link: @link, up: -1)).to eq ''
      expect(if_voted(user: @user, comment: @comment, up: 1)).to eq ''
      expect(if_voted(user: @user, comment: @comment, up: -1)).to eq ''
    end
  end
end

