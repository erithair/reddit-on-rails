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
end
