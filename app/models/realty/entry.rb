module Realty
  class Entry < ActiveRecord::Base
    self.table_name = "realty"

    paginates_per 5

    attr_accessible :name, :price, :address, :description, :photos_attributes, :category_id

    belongs_to :category, class_name: "Category"
    has_many :photos, class_name: "Photo"
    accepts_nested_attributes_for :photos, allow_destroy: true

    #URL_FORMAT = /\A[\w+\-_]+\z/i

    validates :name, :price, :address, :description, :presence => true
    validates :name, :length => { :maximum => 100 }
    validates_numericality_of :price, :only_integer => true, :greater_than => 0

    default_scope :order => ['realty.created_at desc', 'realty.id desc']
    scope :by_category, ->(category) { where(:category_id => category) }

    class << self
      def list(count = 5)
        self.limit(count).all
      end
    end
  end
end
