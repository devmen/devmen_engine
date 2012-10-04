# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product_item, :class => 'Shop::ProductItem' do
    quantity { rand(1..10) }

    association :product, factory: :product

    after(:build) do |product_item|
      product_item.price = product_item.product.price
      product_item.amount = product_item.price * product_item.quantity
    end
  end

  factory :product_item_with_pictures, :class => 'Shop::ProductItem' do
    quantity { rand(1..10) }

    association :product, factory: :product_with_pictures

    after(:build) do |product_item|
      product_item.price = product_item.product.price
      product_item.amount = product_item.price * product_item.quantity
    end
  end
end
