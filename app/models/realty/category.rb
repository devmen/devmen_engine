class Realty::Category < ActiveRecord::Base
  self.table_name = 'realty_categories'
  attr_accessible :name

  validates :name, presence: true, uniqueness: true

  has_many :realties, class_name: "Entry"
end
