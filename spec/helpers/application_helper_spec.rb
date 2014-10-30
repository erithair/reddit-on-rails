require 'rails_helper'

RSpec.describe ApplicationHelper, :type => :helper do
  before :each do
    @base_title = 'RedditOnRails'
  end

  it "has base title" do
    expect(full_title).to eq @base_title
  end

  it "has full title" do
    expect(full_title('extension')).to eq "extension - #{@base_title}"
  end
end

