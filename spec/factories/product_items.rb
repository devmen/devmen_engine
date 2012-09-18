# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product_item, :class => 'Shop::ProductItem' do
    price 5.5
    quantity 1
    amount 5.5

    association :product, factory: :product
  end
end
