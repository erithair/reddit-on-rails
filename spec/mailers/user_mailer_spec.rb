require "rails_helper"

RSpec.describe UserMailer, :type => :mailer do
  describe "account_activation" do
    before :each do
      @user = create(:user)
      @user.activation_token = @user.send(:new_token)
      @mail = UserMailer.account_activation(@user)
    end

    it "renders the headers" do
      expect(@mail.subject).to eq("Account activation")
      expect(@mail.to).to eq([@user.email])
      expect(@mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      expect(@mail.body.encoded).to match(@user.username)
      expect(@mail.body.encoded).to match(@user.activation_token)
    end
  end

  describe "password_reset" do
    before :each do
      @user = create(:user)
      @user.reset_token = @user.send(:new_token)
      @mail = UserMailer.password_reset(@user)
    end

    it "renders the headers" do
      expect(@mail.subject).to eq("Password reset")
      expect(@mail.to).to eq([@user.email])
      expect(@mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      expect(@mail.body.encoded).to match(@user.reset_token)
    end
  end

end
