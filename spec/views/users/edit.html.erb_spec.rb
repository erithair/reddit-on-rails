require 'rails_helper'

RSpec.describe "users/edit.html.erb", :type => :view do
  it "shows user edit page" do
    assign(:user, create(:user))

    render

    expect(rendered).to have_content 'Edit'
  end
end
