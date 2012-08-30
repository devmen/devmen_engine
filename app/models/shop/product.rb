class Shop::Product < ActiveRecord::Base
  self.table_name = "products"

  attr_accessible :name, :description, :sku, :price, :old_price, :in_stock

  belongs_to :category, inverse_of: :products
  has_many :pictures, class_name: "Picture"
  accepts_nested_attributes_for :pictures, allow_destroy: true

  validates :name, :description, :price, :presence => true  
  validates_numericality_of :price, :only_integer => true, :greater_than_or_equal_to => 0

  default_scope :order => 'products.name'

  scope :present_in_stock, -> { where("in_stock > 0") }
end
