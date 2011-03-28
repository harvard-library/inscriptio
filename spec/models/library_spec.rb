require 'spec_helper'

describe Library do
  it "should have some basic attributes" do
    should validate_presence_of :name
    should have_many(:floors)
  end
end
