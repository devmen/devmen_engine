# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product_category, :class => 'Shop::Category' do
    name { Faker::Lorem.sentence(2) }
    description { Faker::Lorem.paragraphs.join }

    factory :category_with_products do
      association :products, factory: :product
    end
  end
end
