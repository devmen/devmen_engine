class Shop::Category < ActiveRecord::Base
  attr_accessible :depth, :description, :name, :parent_id, :sort
end
