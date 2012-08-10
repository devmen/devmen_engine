require 'spec_helper'

describe Realty::Category do
  it "have a valid fatory" do
    create(:realty_category).should be_valid
  end

  describe ".associations" do
    it { should have_many(:realties) }
  end

  describe ".validation" do
    context "when valid" do
      subject { create(:realty_category) }
      it { should validate_presence_of(:name) }
      it { should validate_uniqueness_of(:name) }
    end

    context "when invalid" do
      subject { create(:realty_category) }
      it { should_not allow_value("").for(:name) }

      it "cannot create two categories with same name" do
        create(:realty_category, name: "Estate")
        build(:realty_category, name: "Estate").should_not be_valid
      end
    end
  end
end
