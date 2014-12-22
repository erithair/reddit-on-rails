require 'rails_helper'

feature 'User' do
  scenario 'sign up' do
    ActionMailer::Base.deliveries.clear

    user = build(:inactivated_user)

    visit root_path
    click_link 'Sign up'
    expect {
      fill_in 'user[username]', with: user.username
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      fill_in 'user[password_confirmation]', with: user.password_confirmation
      click_button 'Create'
    }.to change(User, :count).by(1)
    expect(ActionMailer::Base.deliveries.size).to eql 1
    user = User.find_by(email: user.email)
    expect(user.activated?).to be_falsy
  end
end
