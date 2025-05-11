require 'rails_helper'

RSpec.describe Example, type: :model do
  it "is valid with a name" do
    expect(Example.new(name: "Test")).to be_valid
  end
end
