# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  username          :string(255)
#  email             :string(255)
#  password_digest   :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  remember_digest   :string(255)
#  activation_digest :string(255)
#  activated         :boolean
#  activated_at      :datetime
#  reset_digest      :string(255)
#  reset_sent_at     :datetime
#  links_count       :integer          default(0), not null
#  comments_count    :integer          default(0), not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#

require 'rails_helper'

RSpec.describe User, :type => :model do
  it { should have_secure_password }
  it { should have_many :links }

  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  describe "user name" do
    it "can not be empty" do
      expect(build(:user, username: '')).to_not be_valid
    end

    it "can not be less than 4 characters" do
      expect(build(:user, username: 'aaa')).to_not be_valid
    end

    it "can not be longer than 50 characters" do
      expect(build(:user, username: 'a' * 51)).to_not be_valid
    end
  end

  describe "email" do
    it "can not be empty" do
      expect(build(:user, email: '')).to_not be_valid
    end

    it "transfer to downcase automatically" do
      user = create(:user, email: 'UPCASE@EMAIL.com')
      expect(user.email).to eq 'upcase@email.com'
    end

    it "refuse when format is invalid" do
      invalid_addresses = [
        # normal invalid email addresses
        'plainaddress',
        '#@%^%#$@#$@#.com',
        '@example.com',
        'Joe Smith <email@example.com>',
        'email.example.com',
        'email@example@example.com',
        'email@example.com (Joe Smith)',
        'email@example',
      ]

      invalid_addresses.each do |email|
        expect(build(:user, email: email)).to_not be_valid
      end
    end

    it "accept when format is valid " do
      valid_addresses = [
        # normal valid email addresses
        'email@example.com',
        'firstname.lastname@example.com',
        'email@subdomain.example.com',
        'firstname+lastname@example.com',
        '"email"@example.com',
        '1234567890@example.com',
        'email@example-one.com',
        '_______@example.com',
        'email@example.name',
        'email@example.museum',
        'email@example.co.jp',
        'firstname-lastname@example.com',
      ]

      valid_addresses.each do |email|
        expect(build(:user, email: email)).to be_valid
      end
    end

    it "must be unique" do
      email = 'test@example.com'
      create(:user, email: email)
      expect(build(:user, email: email)).to_not be_valid
    end
  end

  describe "password" do
    it "can not be empty" do
      expect(build(:user, password: '')).to_not be_valid
    end

    it "can not be less than 6 characters" do
      pwd = '12345'
      expect(build(:user, password: pwd, password_confirmation: pwd)).to_not be_valid
    end

    it "must equals password_confirmation" do
      expect(build(:user, password: 'secret', password_confirmation: 'foobar'))
    end

    it "#authenticated? should return false for a user with nil digest" do
      expect(create(:user).authenticate('')).to be_falsy
    end
  end

  describe "user instance methods" do
    before :each do
      @user = create(:user)
      @link = create(:link)
    end

    describe "#vote" do
      it "vote for a link" do
        expect {
          @user.vote(@link, '1')
        }.to change(Vote, :count).by(1)
      end

      it "can not vote for a link more than once" do
        create(:link_vote, user: @user, votable: @link)
        expect {
          @user.vote(@link, '1')
        }.to_not change(Vote, :count)
      end

      it "vote for a comment" do
        comment = create(:comment)
        expect {
          @user.vote(comment, '1')
        }.to change(Vote, :count).by(1)
      end

      it "can not vote for a comment more than once" do
        comment = create(:comment)
        create(:comment_vote, user: @user, votable: comment)
        expect {
          @user.vote(comment, '1')
        }.to_not change(Vote, :count)
      end
    end

    describe "#comment" do
      it "can not make an empty comment" do
        expect {
          @user.comment(@link, Comment.new(content: ''))
        }.to_not change(Comment, :count)
      end

      it "comment a link" do
        expect {
          @user.comment(@link, Comment.new(content: 'hello.'))
        }.to change(Comment, :count).by(1)
      end
    end

    describe '#counter' do
      it "returns links count" do
        3.times { create(:link, user: @user) }
        @user.reload
        expect(@user.links_count).to eq 3
      end

      it "returns comments count" do
        3.times { create(:comment, user: @user) }
        @user.reload
        expect(@user.comments_count).to eq 3
      end
    end

    describe "#vote_kind" do
      shared_examples_for "users' votes kind" do
        it "returns nil if user not vote" do
          expect(@user.vote_kind(@no_vote_obj)).to be_nil
        end

        it "returns :up if user made an up-vote" do
          expect(@user.vote_kind(@up_vote_obj)).to eq 1
        end

        it "returns :down if user made a down-vote" do
          expect(@user.vote_kind(@down_vote_obj)).to eq -1
        end
      end

      context 'vote of link' do
        before :each do
          @no_vote_obj = create(:link)
          @up_vote_obj = create(:link)
          @down_vote_obj = create(:link)

          create(:link_vote, votable: @up_vote_obj, up: 1, user: @user)
          create(:link_vote, votable: @down_vote_obj, up: -1, user: @user)
        end

        it_behaves_like "users' votes kind"
      end

      context 'vote of comment' do
        before :each do
          @no_vote_obj = create(:comment)
          @up_vote_obj = create(:comment)
          @down_vote_obj = create(:comment)

          create(:comment_vote, votable: @up_vote_obj, up: 1, user: @user)
          create(:comment_vote, votable: @down_vote_obj, up: -1, user: @user)
        end

        it_behaves_like "users' votes kind"
      end
    end
  end
end
