require 'rails_helper'

RSpec.describe User, :type => :model do
  it { should have_secure_password }
  it { should have_many :links }

  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  context "user name" do
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

  context "email" do
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

  context "password" do
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
      expect(create(:user).authenticated?('')).to be_falsy
    end
  end
end
