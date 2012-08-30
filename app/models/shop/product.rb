class Shop::Product < ActiveRecord::Base
  attr_accessible :category_id, :description, :in_stock, :name, :old_price, :price, :sku
end
