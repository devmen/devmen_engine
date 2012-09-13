require 'spec_helper'

describe Shop::Order do
  it "have a valid factory" do
    create(:order).should be_valid
  end

  describe ".associations" do
    it { should have_many(:product_items) }
  end

  describe ".validations" do
    context "when valid" do
      subject { create(:order) }
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:email) }
      it { should validate_presence_of(:address) }
      it { should allow_value(Faker::Internet.email).for(:email) }
    end

    context "when invalid" do
      subject { create(:order) }
      it { should_not allow_value("").for(:name) }
      it { should_not allow_value("").for(:email) }
      it { should_not allow_value("").for(:address) }
      it { should_not allow_value(Faker::Internet.email.gsub('@', '')).for(:email) }
      it { should_not allow_value(Faker::Internet.email.gsub('.', '..')).for(:email) }
    end
  end

  describe ".methods" do
    context "when add product items" do
      let(:order) { create(:order) }
      before do
        order.add (1..3).map { FactoryGirl.create(:product_item) }
        order.save
        order.reload
      end
      it { order.product_items.size.should == 3 }
    end
  end

end
