require 'spec_helper'

describe ContactUs::Entry do
  it "have a valid vactory" do
    create(:contact_us_entry).should be_valid
  end

  describe ".validations" do
    context "when valid" do
      subject { create(:contact_us_entry) }
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:content) }
      it { should validate_presence_of(:email) }
      it { should allow_value("").for(:phone) }
    end

    context "when invalid" do
      subject { create(:contact_us_entry) }
      it { should_not allow_value("").for(:name) }
      it { should_not allow_value("").for(:content) }
      it { should_not allow_value("").for(:email) }
    end
  end
end
