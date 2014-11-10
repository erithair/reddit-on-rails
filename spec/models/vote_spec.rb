require 'rails_helper'

RSpec.describe Vote, :type => :model do
  it { should belong_to :user }
  it { should belong_to :link }

  it "has a valid factory" do
    expect(build(:vote)).to be_valid
  end

  it "up attribute can not be nil" do
    expect(build(:vote, up: nil)).to_not be_valid
  end

  it "must belong to a user" do
    vote = build(:vote)
    vote.user = nil
    expect(vote).to_not be_valid
  end

  it "must belong to a link" do
    vote = build(:vote)
    vote.link = nil
    expect(vote).to_not be_valid
  end

  it "one user can't vote on same link more than once" do
    user = create(:user)
    link = create(:link)
    vote = create(:vote, user: user, link: link)
    expect(build(:vote, user: user, link: link)).to_not be_valid
  end
end
