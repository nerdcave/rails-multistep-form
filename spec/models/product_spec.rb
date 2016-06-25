require 'spec_helper'

describe Product do
  let(:product) { FactoryGirl.build(:product) }
  subject { product }

  it "should be valid and save" do
    expect(product).to be_valid
    expect(product.save).to be_truthy
  end

  it "should have errors if invalid" do
    required_fields = [:name, :quantity, :tags]
    required_fields.each { |field| product[field] = nil }
    expect(product).to_not be_valid
    required_fields.each { |field| expect(product.errors).to have_key(field) }
  end
  
end