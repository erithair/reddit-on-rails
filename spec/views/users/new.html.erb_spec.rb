require 'rails_helper'

RSpec.describe "users/new.html.erb", :type => :view do
  it "show signup page" do
    assign(:user, create(:user))

    render

    expect(rendered).to have_content 'Sign up'
  end
end
