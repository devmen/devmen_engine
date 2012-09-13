require 'spec_helper'

describe Shop::Cart do
  it "have a valid factory" do
    create(:cart).should be_valid
  end

  describe ".associations" do
    it { should have_many(:product_items) }
  end

  describe ".methods" do
    describe "add products" do
      let(:cart) { create(:cart) }
      subject { cart }
      context "when create diffrent product items in a cart" do
        before do
          3.times do
            item = cart.add FactoryGirl.create(:product)
            item.save
          end
          cart.reload
        end
        it { cart.product_items.size.should == 3 }
        it { cart.product_counter.should == 3 }
      end
      context "when create same product items in a cart" do
        before do
          product = FactoryGirl.create(:product)
          3.times do
            item = cart.add product
            item.save
          end
          cart.reload
        end
        it { cart.product_items.size.should == 1 }
        it { cart.product_items.first.quantity.should == 3 }
        it { cart.product_counter.should == 1 }
      end
    end

    describe "release products" do
      let(:cart) { create(:cart_with_products) }
      subject { cart }
      before do
        items = cart.release
        items.each(&:save)
        cart.reload
      end
      it { cart.product_items.size.should == 0 }
      it { cart.product_counter.should be_nil }
    end
  end

end
