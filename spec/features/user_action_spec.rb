require 'rails_helper'

feature 'User' do
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
    link.reload
    expect(link.rank).to eq 1
  end

  scenario 'vote for a comment' do
    user = create(:user)
    link = create(:link)
    comment = create(:comment, link: link)
    login_as(user)

    visit link_path(link)
    click_link "vote-up-comment-#{comment.id}"
    expect(page).to have_content 'vote success'
  end

end
