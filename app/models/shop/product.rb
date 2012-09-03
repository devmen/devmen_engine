class Shop::Product < ActiveRecord::Base
  self.table_name = "products"

  attr_accessible :category_id, :name, :description, :sku, :price, :old_price, :in_stock,
                  :pictures_attributes

  belongs_to :category, inverse_of: :products
  has_many :pictures, class_name: "Picture"
  accepts_nested_attributes_for :pictures, :allow_destroy => true, :reject_if => :empty_image_field?

  validates :name, :description, :price, :presence => true  
  validates_numericality_of :price, :old_price, :in_stock, :greater_than_or_equal_to => 0, :allow_nil => true
  validates_numericality_of :in_stock, :only_integer => true

  default_scope :order => 'products.name'

  scope :present_in_stock, -> { where("in_stock > 0") }

  private

    def empty_image_field?(attributes)
      if self.new_record?
        attributes[:image].blank? && attributes[:image_cache].blank?
      else
        attributes[:image].blank?
      end
    end
end
