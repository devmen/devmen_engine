# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contact_us_entry, class: 'ContactUs::Entry' do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.phone_number }
    content { Faker::Lorem.sentence }
  end
end
