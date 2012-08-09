FactoryGirl.define do
  factory :realty, class: "Realty::Entry" do
    name { Faker::Lorem.sentence }
    address { Faker::Address.street_address }
    description { Faker::Lorem.paragraphs.join }
    price 503
  end
end
