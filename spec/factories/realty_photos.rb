# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :realty_photo, :class => 'Realty::Photo' do
    realty_id 1
    image "MyString"
  end
end
