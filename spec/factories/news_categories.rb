# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :news_category, :class => 'News::Category' do
    name { Faker::Company.name }
  end
end
