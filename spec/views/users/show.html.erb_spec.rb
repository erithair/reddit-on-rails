require 'rails_helper'

RSpec.describe "users/show.html.erb", :type => :view do
  it "shows user info page" do
    user = create(:user)
    assign(:user, user)

    render

    expect(rendered).to have_content user.username
  end
end
