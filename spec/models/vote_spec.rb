# == Schema Information
#
# Table name: votes
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  up           :integer
#  created_at   :datetime
#  updated_at   :datetime
#  votable_id   :integer
#  votable_type :string(255)
#
# Indexes
#
#  index_votes_on_user_id                                  (user_id)
#  index_votes_on_user_id_and_votable_id_and_votable_type  (user_id,votable_id,votable_type) UNIQUE
#  index_votes_on_votable_id_and_votable_type              (votable_id,votable_type)
#

require 'rails_helper'

RSpec.describe Vote, :type => :model do
  # up
  it { should validate_inclusion_of(:up).in_array([1, -1]) }

  # Association
  it { should belong_to :user }
  it { should validate_presence_of :user }
  it { should belong_to :votable }
  it { should validate_presence_of :votable }

  it "has a valid link_vote factory" do
    expect(build(:link_vote)).to be_valid
  end

  it "has a valid comment_vote factory" do
    expect(build(:comment_vote)).to be_valid
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
