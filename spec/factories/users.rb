# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do |user|
    user.name      "Test user"
    user.email     "test@devmen.com"
    user.password  "123321" 
  end

  factory :admin, class: User do |user|
    user.name      "Admin"
    user.email     "admin@devmen.com"
    user.password  "123321"
    user.roles     ['admin']
  end

  factory :manager, class: User do |user|
    user.name      "Manager"
    user.email     "manager@devmen.com"
    user.password  "123321" 
    user.roles     ['manager']
  end
end
