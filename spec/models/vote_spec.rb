require 'rails_helper'

RSpec.describe Vote, :type => :model do
  it { should belong_to :user }

  it "has a valid factory" do
    [:link_vote, :comment_vote].each do |vote_type|
      expect(build(vote_type)).to be_valid
    end
  end

  it "up attribute can not be nil" do
    [:link_vote, :comment_vote].each do |vote_type|
      expect(build(vote_type, up: nil)).to_not be_valid
    end
  end

  it "must belong to a user" do
    [:link_vote, :comment_vote].each do |vote_type|
      vote = build(vote_type)
      vote.user = nil
      expect(vote).to_not be_valid
    end
  end

  it "must belong to a link/comment" do
    vote = build(:link_vote)
    vote.votable = nil
    expect(vote).to_not be_valid
  end

  it "one user can't vote on same link more than once" do
    user = create(:user)
    link = create(:link)
    vote = create(:link_vote, user: user, votable: link)
    expect(build(:link_vote, user: user, votable: link)).to_not be_valid
  end

  it "one user can't vote on same comment more than once" do
    user = create(:user)
    comment = create(:comment)
    vote = create(:comment_vote, user: user, votable: comment)
    expect(build(:comment_vote, user: user, votable: comment)).to_not be_valid
  end

  it "calculate the rank of link" do
    alice = create(:user)
    bob   = create(:user)
    dave  = create(:user)

    link  = create(:link)
    create(:link_vote, up: 1, votable: link, user: alice)
    create(:link_vote, up: 1, votable: link, user: bob)
    create(:link_vote, up: -1, votable: link, user: dave)
    expect(link.rank).to eq 1
  end

  it "calculate the rank of comment" do
    alice = create(:user)
    bob   = create(:user)
    dave  = create(:user)

    comment  = create(:comment)
    create(:comment_vote, up: 1, votable: comment, user: alice)
    create(:comment_vote, up: 1, votable: comment, user: bob)
    create(:comment_vote, up: -1, votable: comment, user: dave)
    expect(comment.rank).to eq 1
  end
end