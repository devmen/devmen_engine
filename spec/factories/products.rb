# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product, :class => 'Shop::Product' do
    name { Faker::Lorem.sentence(2) }
    description { Faker::Lorem.paragraphs.join }
    sku { Faker::Lorem.numerify('########') }
    price 9.99
    old_price 9.99
    in_stock 5
  end
end
