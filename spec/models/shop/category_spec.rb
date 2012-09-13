require 'spec_helper'

describe Shop::Category do
  it "have a valid factory" do
    create(:product_category).should be_valid
  end

  describe ".associations" do
    it { should have_many(:products) }
  end

  describe ".validations" do
    context "when valid" do
      subject { create(:product_category) }
      it { should validate_presence_of(:name) }
      it { should validate_uniqueness_of(:name) }
      it { should allow_value("a" * 100).for(:name) }
    end

    context "when invalid" do
      let(:category) { create(:product_category) }
      subject { category }
      it { should_not allow_value("").for(:name) }
      it { should_not allow_value("a" * 101).for(:name) }
      context "name uniquennes" do
        let(:invalid_category) { build(:product_category, name: category.name) }
        it { invalid_category.should_not be_valid }
        it "should not save" do
          invalid_category.save.should == false
        end
      end
    end
  end

  describe '.ancestry' do
    let(:category) { create(:product_category) }
    let(:subcategory) { create(:product_category, parent_id: category.id) }
    context "when there is an ancestry" do
      # it { category.descendants.should include subcategory }
      it { subcategory.ancestors.should include category }
    end
    context "when there isn't an ancestry" do
      let(:other_category) { create(:product_category) }
      it { other_category.descendants.should_not include subcategory }
      it { subcategory.ancestors.should_not include other_category }
    end
  end
end
