require 'spec_helper'

describe Floor do
  it "should have some basic attributes" do
    should belong_to(:library)
  end
end
