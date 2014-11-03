require 'rails_helper'

RSpec.describe "links/show.html.erb", :type => :view do
  it "shows the link's title" do
    pending
    link = create(:link)
    assign(:link, link)

    render

    expect(rendered).to have_content link.title
  end
end
