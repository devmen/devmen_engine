# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product_picture, :class => 'Shop::Picture' do
    name { Faker::Lorem.words.join(' ') }
  end
end
