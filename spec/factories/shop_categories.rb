# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shop_category, :class => 'Shop::Category' do
    parent_id 1
    name "MyString"
    description "MyText"
    depth 1
    sort 1
  end
end
