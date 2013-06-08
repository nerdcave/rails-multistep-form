require 'spec_helper'

describe Product do
  let(:product) { FactoryGirl.build(:product) }
  subject { product }

  it "should be valid and save" do
    product.should be_valid
    product.save.should be_true
  end

  it "should have errors if invalid" do
    required_fields = [:name, :quantity, :tags]
    required_fields.each { |field| product[field] = nil }
    product.should_not be_valid
    required_fields.each { |field| product.errors.has_key?(field).should be_true }
  end
  
end