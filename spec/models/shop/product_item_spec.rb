require 'spec_helper'

describe Shop::ProductItem do
  it "have a valid factory" do
    create(:product_item).should be_valid
  end

  describe ".associations" do
    it { should belong_to(:product) }
    it { should belong_to(:cart) }
    it { should belong_to(:order) }
  end
end
