require 'rails_helper'

feature 'User' do
  scenario "sign up" do
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
    expect(ActionMailer::Base.deliveries.size).to eq 1
    user = User.find_by(email: user.email)
    expect(user.activated?).to be_falsy
    # trouble with testing activation. user.activation_token is nil ???
  end

  context "log in" do
    before :each do
      @user = create(:user)
    end

    scenario "with valid info" do
      login_as(@user)
      expect(page).to have_content 'Log in success'
      expect(page).to have_content @user.username

      visit user_path(@user)
      click_link 'Log out'
      expect(page).to have_content 'Log out success'
      expect(page).to_not have_content @user.username
    end

    scenario "with invalid info" do
      login_as(@user, password: 'invalid')
      expect(page).to have_content 'Invalid info'
      expect(page).to_not have_content @user.username
    end

    context 'with friendly forwarding when' do
      scenario 'submit a new link' do
        visit new_link_path
        login_as(@user)
        expect(current_path).to eq new_link_path
        expect(page).to have_content 'New link'
        fill_in 'link[url]', with: 'http://foobar.com/foo.jpg'
        fill_in 'link[title]', with: 'Foo Bar'
        click_button 'Submit'
        expect(page).to have_content 'create a new link'
        expect(page).to have_content 'Foo Bar'
      end

      scenario 'edit a link' do
        link = create(:link, user: @user)
        visit edit_link_path(link)
        login_as(@user)
        expect(current_path).to eq edit_link_path(link)
        expect(page).to have_content 'Edit link'
        fill_in 'link[title]', with: 'Another Title'
        click_button 'Update'
        expect(page).to have_content 'Another Title'
      end
    end
  end

  scenario 'password reset' do
    pending "reset_token nil? ???"
    ActionMailer::Base.deliveries.clear
    user = create(:user)

    visit new_password_reset_path
    expect(current_path).to eq new_password_reset_path

    # Invalid email
    fill_in 'password_reset[email]', with: 'wrong@email.com'
    click_button 'Submit'
    expect(page).to have_content 'Email address not found.'

    # Valid email
    fill_in 'password_reset[email]', with: user.email
    click_button 'Submit'
    expect(ActionMailer::Base.deliveries.size).to eq 1
    expect(current_path).to eq root_path

    user.reload

    # Inactive user
    user.toggle!(:activated)
    # id: nil ???? reset_token nil ???
    visit edit_password_reset_path(user.reset_token, email: user.email)
    expect(current_path).to eq root_path

    # Wrong email
    visit edit_password_reset_path(user.reset_token, email: '')
    expect(current_path).to eq root_path

    # Right email, wrong token
    visit edit_password_reset_path('wrong token', email: user.email)
    expect(current_path).to eq root_path

    # Right email, right token
    visit edit_password_reset_path(user.reset_token, email: user.email)
    expect(current_path).to eq root_path

    # Blank password & password_confirmation
    fill_in 'password_reset[password]', with: ''
    fill_in 'password_reset[password_confirmation]', with: ''
    click_button 'Update password'
    expect(page).to have_content "Password/confirmation can't be blank"
    expect(current_path).to eq edit_password_reset_path(user)

    # Invalid password & pasword_confirmation
    fill_in 'password_reset[password]', with: 'fffeee'
    fill_in 'password_reset[password_confirmation]', with: 'eeefff'
    click_button 'Update password'
    expect(current_path).to eq edit_password_reset_path(user)

    # Valid password & password_confirmation
    fill_in 'password_reset[password]', with: 'foobar'
    fill_in 'password_reset[password_confirmation]', with: 'foobar'
    click_button 'Update password'
    expect(page).to have_content "Password has been reset."
    expect(current_path).to eq user_path(user)

  end

  scenario 'submit a new link' do
    user = create(:user)
    login_as(user)

    visit new_link_path
    fill_in 'link[url]', with: 'http://foobar.com/foo.jpg'
    fill_in 'link[title]', with: 'Foo Bar'
    click_button 'Submit'
    expect(page).to have_content 'create a new link'
    expect(page).to have_content 'Foo Bar'
  end

  scenario 'make a comment' do
    user = create(:user)
    link = create(:link)
    login_as(user)
    visit link_path(link)
    fill_in 'comment[content]', with: 'Foo Bar'
    click_button 'Comment'
    expect(page).to have_content "#{user.username} commented"
    expect(page).to have_content "Foo Bar"
  end

  scenario 'vote for a link' do
    user = create(:user)
    link = create(:link)
    login_as(user)

    visit root_path
    click_link "vote-up-link-#{link.id}"
    expect(page).to have_content 'vote success'
    expect(link.rank).to eq 1
  end

end
