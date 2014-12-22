# == Schema Information
#
# Table name: links
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  url            :string(255)
#  title          :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  comments_count :integer          default(0), not null
#  rank           :integer          default(0), not null
#
# Indexes
#
#  index_links_on_user_id  (user_id)
#

require 'rails_helper'

RSpec.describe Link, :type => :model do
  # title
  it { should validate_presence_of :title }
  it { should ensure_length_of(:title).is_at_most(200) }

  # url
  it { should validate_presence_of :url }
  it { should allow_value('http://www.foo-bar.com/valid_url').for(:url) }
  it { should allow_value('https://www.foo-bar.com/valid_url').for(:url) }
  it { should_not allow_value('asdaw_dwa&12a::daw').for(:url) }

  # Association
  it { should belong_to :user }
  it { should validate_presence_of :user }

  it "has a valid factory" do
    expect(build(:link)).to be_valid
  end

  describe "order" do
    before :each do
      @link1 = create(:link)
      @link2 = create(:link)
      @link3 = create(:link)
    end

    it "sorted by created time DESC" do
      expect(Link.order_by(:latest).to_a).to eql [@link3, @link2, @link1]
    end

    it "sorted by rank(votes count)" do
      create(:link_vote, votable: @link1, up: -1)
      create(:link_vote, votable: @link2, up: 1)

      expect(Link.order_by(:rank).to_a).to eql [@link2, @link3, @link1]
    end

    it "sorted by popularity(comments count)" do
      create(:comment, link: @link1)
      2.times { create(:comment, link: @link2) }

      expect(Link.order_by(:hot).to_a).to eql [@link2, @link1, @link3]
    end
  end

  describe "counter" do
    before :each do
      @link = create(:link)
    end

    it "returns comments count" do
      3.times { create(:comment, link: @link) }
      @link.reload
      expect(@link.comments_count).to eql 3
    end
  end
end
