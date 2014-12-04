require 'rails_helper'

RSpec.describe SearchHelper, :type => :helper do
  describe "#parse_search_param" do
    it "regular search" do
      search_info = parse_search_param('foo bar')
      expect(search_info).to eq ['foo bar', :latest]
    end

    it "search with specific order" do
      search_info = parse_search_param('foo bar&:order')
      expect(search_info).to eq ['foo bar', :order]
    end
  end
end
