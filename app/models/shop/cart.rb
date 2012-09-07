class Shop::Cart < ActiveRecord::Base
  attr_accessible :product_items_attributes

  has_many :product_items, dependent: :destroy, inverse_of: :cart
  accepts_nested_attributes_for :product_items, :allow_destroy => true, :reject_if => Proc.new { |atrs| atrs[:id].blank? }

  def add(product, quantity = 1)
    item = product_items.where(:product_id => product.id).first
    if item
      item.price = item.product.price      
      item.quantity += quantity.to_i
      item.amount = item.price * item.quantity
    else
      amount = product.price * quantity.to_i
      item = product_items.build(product: product, price: product.price, quantity: quantity, amount: amount)      
    end
    item
  end

  def release
    product_items.each { |item| item.cart_id = nil }
  end
end
