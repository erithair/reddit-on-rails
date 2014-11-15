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
