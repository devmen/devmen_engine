class Shop::ProductItem < ActiveRecord::Base
  attr_accessible :product, :price, :quantity, :amount

  belongs_to :product, inverse_of: :product_items
  belongs_to :cart, counter_cache: :product_counter, inverse_of: :product_items
  belongs_to :order, inverse_of: :product_items

  default_scope order: 'product_items.id'
end
