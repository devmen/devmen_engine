# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shop_product_item, :class => 'Shop::ProductItem' do
    quantity 1
    product_id 1
    cart_id 1
    order_id 1
  end
end
