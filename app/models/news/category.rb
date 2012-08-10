class News::Category < ActiveRecord::Base
  self.table_name = "news_categories"

  attr_accessible :name

  has_many :news, class_name: "Entry"

  validates :name, presence: true, uniqueness: true
end
