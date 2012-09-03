class Shop::Picture < ActiveRecord::Base
  self.table_name = "product_pictures"

  attr_accessible :image, :image_cache, :name, :product_id

  belongs_to :product

  mount_uploader :image, PictureUploader

  before_save do |picture|
    picture.name = picture.image.identifier.gsub(/\.\w+$/, '').humanize if picture.name.blank?
  end

  default_scope :order => 'product_pictures.id'
end
