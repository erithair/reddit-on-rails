require 'rails_helper'

feature 'User' do
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
end
