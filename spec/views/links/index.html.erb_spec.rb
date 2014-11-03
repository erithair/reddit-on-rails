require 'rails_helper'

RSpec.describe "links/index.html.erb", :type => :view do
  it "shows all links' title" do
    links = 3.times.map { create(:link) }
    assign(:links, Link.all)

    render

    links.each do |link|
      expect(rendered).to have_content link.title
    end
  end
end
