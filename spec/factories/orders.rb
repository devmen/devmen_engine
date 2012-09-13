# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order, :class => 'Shop::Order' do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    address { Faker::Address.street_address }
    num { Faker::Lorem.numerify('########') }
  end
end
