require 'rails_helper'

RSpec.describe "links/show.html.erb", :type => :view do
  it "shows the link's title" do
    link = create(:link)
    create(:comment, link: link)
    assign(:link, link)
    assign(:comment, Comment.new)
    assign(:comments, link.comments)

    render

    expect(rendered).to have_content link.title
  end
end
