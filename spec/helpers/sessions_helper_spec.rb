require 'rails_helper'

RSpec.describe SessionsHelper, :type => :helper do
  describe "#current_user" do
    before :each do
      @user = create(:user)
      remember(@user)
    end

    it "returns right user when session is nil" do
      expect(current_user).to eql @user
      expect logged_in?
    end

    it "returns nil when remember digest is wrong" do
      @user.update_attribute(:remember_digest, BCrypt::Password.create(SecureRandom.urlsafe_base64))
      expect(current_user).to be_nil
    end
  end

end
