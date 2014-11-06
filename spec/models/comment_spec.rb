require 'rails_helper'

RSpec.describe Comment, :type => :model do
  it { should belong_to :user }
  it { should belong_to :link }

  it "has a valid factory" do
    expect(build(:comment)).to be_valid
  end

  context "content" do
    it "can not be empty" do
      expect(build(:comment, content: '')).to_not be_valid
    end

    it "can not longer than 1000 characters" do
      pending "unsure"
      expect(build(:comment, content: 'a' * 1001)).to_not be_valid
    end
  end

  it "must belong to a user" do
    comment = build(:comment)
    comment.user = nil
    expect(comment).to_not be_valid
  end

  it "must belong to a link" do
    comment = build(:comment)
    comment.link = nil
    expect(comment).to_not be_valid
  end
end
