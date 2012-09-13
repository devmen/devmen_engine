class Shop::Product < ActiveRecord::Base
  extend FriendlyId

  self.table_name = "products"

  attr_accessible :category_id, :name, :description, :sku, :price, :old_price, :in_stock, :slug,
                  :pictures_attributes

  belongs_to :category, inverse_of: :products
  has_many :pictures, inverse_of: :product
  has_many :product_items, inverse_of: :product

  accepts_nested_attributes_for :pictures, :allow_destroy => true, :reject_if => :empty_image_field?

  friendly_id :name, :use => [:slugged, :history],
              :reserved_words => %w(index new session login logout users admin images markitup elfinder)

  validates :name, :description, :price, :presence => true
  validates :name, :length => { :maximum => 100 }
  validates_numericality_of :price, :old_price, :greater_than_or_equal_to => 0, :allow_nil => true
  validates_numericality_of :in_stock, :only_integer => true, :greater_than_or_equal_to => 0, :allow_nil => true

  default_scope :order => 'products.name'

  scope :by_category, ->(category) { where(:category_id => ::Shop::Category.find(category).self_and_descendants.select(:id)) }
  scope :present_in_stock, -> { where("in_stock > 0") }

  before_destroy :ensure_not_referenced_by_any_product_item

  private

    def empty_image_field?(attributes)
      if self.new_record?
        attributes[:image].blank? && attributes[:image_cache].blank?
      else
        attributes[:image].blank?
      end
    end

    def should_generate_new_friendly_id?
      slug.blank?
    end

    def ensure_not_referenced_by_any_product_item
      if product_items.count.zero?
        return true
      else
        errors.add(:base, 'Product items present' )
        return false
      end
    end

end
