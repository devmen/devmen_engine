FactoryGirl.define do
  factory :news_entry, class: "News::Entry" do
    name { Faker::Lorem.sentence }
    text { Faker::Lorem.paragraphs.join }
    date Date.today
  end
end
