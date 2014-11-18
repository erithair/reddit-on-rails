require 'rails_helper'

RSpec.describe SearchController, :type => :controller do
  describe "GET #index" do
    it "returns the links match search-query " do
      key_word = 'foobar'
      match_link1 = create(:link, title: "this is one link includes #{key_word}.")
      match_link2 = create(:link, title: "#{key_word} is included in this link too.")

      not_match_link = create(:link, title: "key word is not included in this linkl.")

      get :index, q: 'foobar'
      expect(assigns(:links)).to match_array [match_link1, match_link2]
    end
  end
end
