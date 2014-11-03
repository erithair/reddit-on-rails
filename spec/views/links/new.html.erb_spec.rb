require 'rails_helper'

RSpec.describe "links/new.html.erb", :type => :view do
  it "shows new link form" do
    pending
    assign(:link, create(:link))

    render

    expect(rendered).to have_content 'New link'
  end
end
