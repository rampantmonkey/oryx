require_relative '../../test_helper'
describe Oryx do
  it "must be defined" do
    Oryx::VERSION.wont_be_nil
  end
end
