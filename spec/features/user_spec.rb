require 'rails_helper'

feature 'User' do
  scenario "sign up" do
    user = build(:user)

    visit root_path
    click_link 'Sign up'
    expect {
      fill_in 'user[username]', with: user.username
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      fill_in 'user[password_confirmation]', with: user.password_confirmation
      click_button 'Create'
    }.to change(User, :count).by(1)
    expect(page).to have_content 'Sign up success'
  end

  context "with valid info" do
    scenario "log in/out" do
      user = create(:user)
      visit root_path
      click_link 'Log in'
      fill_in 'session[email]', with: user.email
      fill_in 'session[password]', with: user.password
      click_button 'Log in'
      expect(page).to have_content 'Log in success'
      expect(page).to have_content user.username

      visit user_path(user)
      click_link 'Log out'
      expect(page).to have_content 'Log out success'
      expect(page).to_not have_content user.username
    end
  end

  context "with invalid info" do
    scenario "log in failed" do
      user = create(:user)
      visit root_path
      click_link 'Log in'
      fill_in 'session[email]', with: user.email
      fill_in 'session[password]', with: 'invalid'
      click_button 'Log in'
      expect(page).to have_content 'Invalid info'
      expect(page).to_not have_content user.username
    end
  end

end
