# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order, :class => 'Shop::Order' do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    address { Faker::Address.street_address }

    factory :order_with_products do
      before(:create) do |order|
        product_items = []
        3.times { product_items << FactoryGirl.create(:product_item, quantity: rand(1..10)) }
        order.add product_items
      end
    end

    factory :order_with_products_and_pictures do
      before(:create) do |order|
        product_items = []
        2.times { product_items << FactoryGirl.create(:product_item_with_pictures, quantity: rand(1..10)) }
        order.add product_items
      end
    end
  end
end
