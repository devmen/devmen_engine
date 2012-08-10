# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :realty_category, :class => 'Realty::Category' do
    name "Estate"
  end
end
