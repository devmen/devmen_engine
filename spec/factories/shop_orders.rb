# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shop_order, :class => 'Shop::Order' do
    name "MyString"
    email "MyString"
    address "MyText"
    num 1
  end
end
