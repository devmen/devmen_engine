# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :review_entry, :class => 'Review::Entry' do
    name "MyString"
    content "MyText"
    visible false
  end
end
