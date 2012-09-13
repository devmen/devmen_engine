# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product_picture, :class => 'Shop::Picture' do
    image "MyString"
    product_id 1
    name "MyString"
  end
end
