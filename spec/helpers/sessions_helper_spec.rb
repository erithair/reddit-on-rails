require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the SessionsHelper. For example:
#
# describe SessionsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe SessionsHelper, :type => :helper do
  context "#current_user" do
    before :each do
      @user = create(:user)
      remember(@user)
    end

    it "returns right user when session is nil" do
      expect(current_user).to eq @user
      expect logged_in?
    end

    it "returns nil when remember digest is wrong" do
      @user.update_attribute(:remember_digest, BCrypt::Password.create(SecureRandom.urlsafe_base64))
      expect(current_user).to be_nil
    end
  end

end
