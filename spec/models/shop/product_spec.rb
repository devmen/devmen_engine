require 'spec_helper'

describe Shop::Product do
  it "have a valid factory" do
    create(:product).should be_valid
  end

  describe ".associations" do
    it { should belong_to(:category) }
    it { should have_many(:pictures) }
    it { should have_many(:product_items) }
  end

  describe ".validations" do
    context "when valid" do
      subject { create(:product) }
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:price) }
      it { should validate_presence_of(:description) }
      it { should validate_numericality_of(:price) }
      it { should validate_numericality_of(:old_price) }
      it { should validate_uniqueness_of(:slug) }
      it { should allow_value("a" * 100).for(:name) }
      it { should allow_value(5.5).for(:price) }
      it { should allow_value(5.5).for(:old_price) }
      it { should allow_value(5).for(:in_stock) }
    end

    context "when invalid" do
      let(:product) { create(:product) }
      subject { product }
      it { should_not allow_value("").for(:name) }
      it { should_not allow_value("").for(:price) }
      it { should_not allow_value("").for(:description) }
      it { should_not allow_value("a").for(:price) }
      it { should_not allow_value("a").for(:old_price) }
      it { should_not allow_value("a" * 101).for(:name) }
      it { should_not allow_value(-1).for(:price) }
      it { should_not allow_value(-1).for(:old_price) }
      it { should_not allow_value(5.5).for(:in_stock) }
      it { should_not allow_value(-1).for(:in_stock) }
      context "slug uniquennes" do
        let(:invalid_product) { build(:product, slug: product.slug) }
        it { invalid_product.should_not be_valid }
        it "should not save" do
          invalid_product.save.should == false
        end
      end
    end
  end
end
