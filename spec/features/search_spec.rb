require 'rails_helper'

feature 'Search' do
  scenario 'search for links' do
    key_word = 'foobar'
    match_link1 = create(:link, title: "this is one link includes #{key_word}.")
    match_link2 = create(:link, title: "#{key_word} is included in this link too.")

    not_match_link = create(:link, title: "key word is not included in this linkl.")

    visit root_path
    fill_in 'q', with: key_word
    click_button 'Search'

    expect(page).to have_content match_link1.title
    expect(page).to have_content match_link2.title

    expect(page).to_not have_content not_match_link.title
  end
end