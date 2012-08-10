require 'spec_helper'

describe Realty::Entry do
  it "have a valid factory" do
    create(:realty).should be_valid
  end

  describe ".associations" do
    it { should belong_to(:category) }
    it { should have_many(:photos) }
  end

  describe ".validations" do
    context "when valid" do
      subject { create(:realty) }
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:price) }
      it { should validate_presence_of(:address) }
      it { should validate_presence_of(:description) }
      it { should validate_numericality_of(:price) }
      it { should allow_value("a" * 100).for(:name) }
    end

    context "when invalid" do
      subject { create(:realty) }
      it { should_not allow_value("").for(:name) }
      it { should_not allow_value("").for(:price) }
      it { should_not allow_value("").for(:address) }
      it { should_not allow_value("").for(:description) }
      it { should_not allow_value("a").for(:price) }
      it { should_not allow_value(-1).for(:price) }
      it { should_not allow_value("a" * 101).for(:name) }
    end
  end
end
