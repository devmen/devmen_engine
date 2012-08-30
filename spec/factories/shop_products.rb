# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shop_product, :class => 'Shop::Product' do
    name "MyString"
    description "MyText"
    sku "MyString"
    price "9.99"
    old_price "9.99"
    in_stock 1
    category_id 1
  end
end
