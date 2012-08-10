class Realty::Photo < ActiveRecord::Base
  self.table_name = "realty_photos"

  attr_accessible :image, :entry_id

  belongs_to :realty, class_name: "Entry"

  mount_uploader :image, PictureUploader
end
