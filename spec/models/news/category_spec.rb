require 'spec_helper'

describe News::Category do
  it "have a valid fatory" do
    create(:news_category).should be_valid
  end

  describe ".associations" do
    it { should have_many(:news) }
  end

  describe ".validation" do
    context "when valid" do
      subject { create(:news_category) }
      it { should validate_presence_of(:name) }
      it { should validate_uniqueness_of(:name) }
    end

    context "when invalid" do
      subject { create(:news_category) }
      it { should_not allow_value("").for(:name) }

      it "cannot create two categories with same name" do
        create(:news_category, name: "Company News")
        build(:news_category, name: "Company News").should_not be_valid
      end
    end
  end
end
