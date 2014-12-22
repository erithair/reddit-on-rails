# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  content    :text
#  user_id    :integer
#  link_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  rank       :integer          default(0), not null
#
# Indexes
#
#  index_comments_on_link_id  (link_id)
#  index_comments_on_user_id  (user_id)
#

require 'rails_helper'

RSpec.describe Comment, :type => :model do
  # content
  it { should validate_presence_of :content }
  # not constraint yet.
  # it { should ensure_length_of(:content).is_at_most(1000) }

  # Association
  it { should belong_to :user }
  it { should validate_presence_of :user }
  it { should belong_to :link }
  it { should validate_presence_of :link }

  it "has a valid factory" do
    expect(build(:comment)).to be_valid
  end

  describe "order" do
    before :each do
      @comment1 = create(:comment)
      @comment2 = create(:comment)
      @comment3 = create(:comment)
    end

    it "sorted by created time DESC" do
      expect(Comment.order_by(:latest).to_a).to eql [@comment3, @comment2, @comment1]
    end

    it "sorted by rank(votes count)" do
      create(:comment_vote, votable: @comment1, up: -1)
      create(:comment_vote, votable: @comment2, up: 1)

      expect(Comment.order_by(:rank).to_a).to eql [@comment2, @comment3, @comment1]
    end
  end
end
