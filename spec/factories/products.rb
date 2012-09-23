# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product, :class => 'Shop::Product' do
    name { Faker::Lorem.words.join(' ') }
    description { Faker::Lorem.paragraphs.join }
    sku { Faker::Lorem.numerify('########') }
    price 9.99
    old_price 9.99
    in_stock 5

    factory :product_with_pictures do
      after(:build) do |product|
        2.times { product.pictures << FactoryGirl.build(:product_picture, image: File.open("#{Rails.root}/spec/factories/test-image.jpg")) }
      end
    end
  end
end
