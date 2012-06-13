# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :page do
    # name "Test page"
    # url "test_page"
    # body "<h1>Test page</h1><p>Some html</p>"

    sequence(:name) { |n| "Test page #{n}" }
    sequence(:url) { |n| "test_page_#{n}" }
    # sequence(:body) { |n| "<h1>Test page #{n}</h1><p>Some html</p>" }
    sequence(:body) { |n| "Some text #{n}" }
  end
end
