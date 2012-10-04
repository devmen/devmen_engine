# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cart, :class => 'Shop::Cart' do
    # association :product_items, factory: product_item

    factory :cart_with_products do
      before(:create) do |cart|
        2.times { cart.add FactoryGirl.create(:product), rand(1..10) }
      end
    end

    factory :cart_with_products_and_pictures do
      before(:create) do |cart|
        2.times { cart.add FactoryGirl.create(:product_with_pictures), rand(1..10) }
      end
    end
  end
end
