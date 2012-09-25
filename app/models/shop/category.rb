class Shop::Category < ActiveRecord::Base
  self.table_name = 'product_categories'

  attr_accessible :parent_id, :name, :description, :depth, :sort

  has_many :products, inverse_of: :category, dependent: :nullify

  validates :name, presence: true, uniqueness: { scope: :parent_id }, length: { maximum: 100 }

  acts_as_nested_set :dependent => :destroy

  default_scope order: ['product_categories.parent_id', 'product_categories.lft']

end
