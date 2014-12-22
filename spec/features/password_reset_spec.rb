require 'rails_helper'

feature 'User' do
  scenario 'password reset' do
    pending "reset_token nil? ???"
    ActionMailer::Base.deliveries.clear
    user = create(:user)

    visit new_password_reset_path
    expect(current_path).to eql new_password_reset_path

    # Invalid email
    fill_in 'password_reset[email]', with: 'wrong@email.com'
    click_button 'Submit'
    expect(page).to have_content 'Email address not found.'

    # Valid email
    fill_in 'password_reset[email]', with: user.email
    click_button 'Submit'
    expect(ActionMailer::Base.deliveries.size).to eql 1
    expect(current_path).to eql root_path

    user.reload

    # Inactive user
    user.toggle!(:activated)
    # id: nil ???? reset_token nil ???
    visit edit_password_reset_path(user.reset_token, email: user.email)
    expect(current_path).to eql root_path

    # Wrong email
    visit edit_password_reset_path(user.reset_token, email: '')
    expect(current_path).to eql root_path

    # Right email, wrong token
    visit edit_password_reset_path('wrong token', email: user.email)
    expect(current_path).to eql root_path

    # Right email, right token
    visit edit_password_reset_path(user.reset_token, email: user.email)
    expect(current_path).to eql root_path

    # Blank password & password_confirmation
    fill_in 'password_reset[password]', with: ''
    fill_in 'password_reset[password_confirmation]', with: ''
    click_button 'Update password'
    expect(page).to have_content "Password/confirmation can't be blank"
    expect(current_path).to eql edit_password_reset_path(user)

    # Invalid password & pasword_confirmation
    fill_in 'password_reset[password]', with: 'fffeee'
    fill_in 'password_reset[password_confirmation]', with: 'eeefff'
    click_button 'Update password'
    expect(current_path).to eql edit_password_reset_path(user)

    # Valid password & password_confirmation
    fill_in 'password_reset[password]', with: 'foobar'
    fill_in 'password_reset[password_confirmation]', with: 'foobar'
    click_button 'Update password'
    expect(page).to have_content "Password has been reset."
    expect(current_path).to eql user_path(user)
  end
end
