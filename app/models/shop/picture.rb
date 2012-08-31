class Shop::Picture < ActiveRecord::Base
  self.table_name = "product_pictures"

  attr_accessible :image, :name, :product_id

  belongs_to :product

  mount_uploader :image, PictureUploader
end
