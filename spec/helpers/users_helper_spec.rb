require 'rails_helper'

RSpec.describe UsersHelper, :type => :helper do
  describe "#active_if_exist()" do
    it "be active when exist" do
      expect(active_if_exist(Object.new)).to eq 'active'
    end

    it "not be active when not exist" do
      expect(active_if_exist(nil)).to eq ''
    end
  end
end
