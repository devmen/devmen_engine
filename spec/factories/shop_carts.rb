# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shop_cart, :class => 'Shop::Cart' do
    product_counter 1
  end
end
