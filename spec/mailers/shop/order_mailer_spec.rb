require 'spec_helper'

describe Shop::OrderMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  let(:order) { create(:order_with_products) }
  subject { Shop::OrderMailer.order_message(order) }

  describe "with configuration data" do
    it { should deliver_from CFG['shop']['from_email'] }
    it { should bcc_to CFG['shop']['bcc_email'] }
    it { should have_body_text(/#{CFG['shop']['url']}/) }
    it { should have_body_text(/#{CFG['shop']['name']}/) }
  end

  describe "with the order data" do
    it { should deliver_to order.email }
    it { should have_subject I18n.t('order_mail_message', default: "Order number #{order.num}", :num => order.num) }
    it { should have_body_text(/#{order.name}/) }
    it { should have_body_text(/#{order.num}/) }
    it { should have_body_text(/#{I18n.l(order.created_at.to_date, format: :long)}/) }
    it "should contain ordered products" do
      order.product_items.each { |item| should have_body_text(/#{item.product.name}/) }
    end
  end

end
