class Shop::Category < ActiveRecord::Base
  self.table_name = 'product_categories'
  
  attr_accessible :name, :description, :depth, :sort

  has_many :products, inverse_of: :category
  has_many :subcategories, class_name: 'Category', foreign_key: "parent_id"
  belongs_to :parent, class_name: 'Category'

  validates :name, presence: true, uniqueness: {scope: :parent_id}

end
