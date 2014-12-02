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
#

require 'rails_helper'

RSpec.describe Link, :type => :model do
  it { should belong_to :user }

  it "has a valid factory" do
    expect(build(:link)).to be_valid
  end

  context "url" do
    it "can not be empty" do
      expect(build(:link, url: '')).to_not be_valid
    end

    it "can not have invalid format" do
      invalid_links = [
        'dwadwad',
        'asdaw_dwa&12a::daw',
        'www.foobar.com'
      ]
      invalid_links.each do |url|
        expect(build(:link, url: url)).to_not be_valid
      end
    end

    it "can have valid format" do
      valid_links = [
        'http://www.foobar.com/valid_url',
        'http://www.foo-bar.com/valid_url',
        'https://www.foo-bar.com/valid_url',
        'https://www.foobar.com/valid_url'
      ]
      valid_links.each do |url|
        expect(build(:link, url: url)).to be_valid
      end
    end
  end

  context "title" do
    it "can not be empty" do
      expect(build(:link, title: '')).to_not be_valid
    end

    it "can not be longer than 200 characters" do
      expect(build(:link, title: 'a' * 201)).to_not be_valid
    end
  end

  it "must belong to a user" do
    link = build(:link)
    link.user = nil
    expect(link).to_not be_valid
  end

  context "order" do
    before :each do
      @link1 = create(:link)
      @link2 = create(:link)
      @link3 = create(:link)
    end

    it "sorted by created time DESC" do
      expect(Link.order_by(:latest).first).to eq @link3
    end

    it "sorted by rank(votes count)" do
      create(:link_vote, votable: @link1, up: -1)
      create(:link_vote, votable: @link2, up: 1)

      expect(Link.order_by(:rank).first).to eq @link2
      expect(Link.order_by(:rank).last).to eq @link1
    end

    it "sorted by hot(comments count)" do
      create(:comment, link: @link1)
      2.times { create(:comment, link: @link2) }

      expect(Link.order_by(:hot).first).to eq @link2
      expect(Link.order_by(:hot).last).to eq @link3
    end
  end

  context "counter" do
    before :each do
      @link = create(:link)
    end

    it "returns comments count" do
      3.times { create(:comment, link: @link) }
      @link.reload
      expect(@link.comments_count).to eq 3
    end
  end
end
