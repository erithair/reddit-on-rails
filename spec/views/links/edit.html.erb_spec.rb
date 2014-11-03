require 'rails_helper'

RSpec.describe "links/edit.html.erb", :type => :view do
  it "shows edit form" do
    pending
    assign(:link, create(:link))

    render

    expect(rendered).to have_content 'Edit'
  end
end
