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

  context "log in failed" do
    scenario "with valid info" do
      user = create(:user)
      login_as(user)
      expect(page).to have_content 'Log in success'
      expect(page).to have_content user.username

      visit user_path(user)
      click_link 'Log out'
      expect(page).to have_content 'Log out success'
      expect(page).to_not have_content user.username
    end

    scenario "with invalid info" do
      user = create(:user)
      login_as(user, password: 'invalid')
      expect(page).to have_content 'Invalid info'
      expect(page).to_not have_content user.username
    end
  end

  scenario 'submit a new link and then delete it' do
    user = create(:user)
    login_as(user)

    visit root_path
    fill_in 'link[url]', with: 'http://foobar.com/foo.jpg'
    fill_in 'link[title]', with: 'Foo Bar'
    click_button 'Submit'
    expect(page).to have_content 'create a new link'
    expect(page).to have_content 'Foo Bar'

    # delete it
    click_link 'Delete'
    expect(page).to_not have_content 'create a new link'
    expect(page).to_not have_content 'Foo Bar'
  end

end
