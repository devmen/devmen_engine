module Realty
  class Entry < ActiveRecord::Base
    self.table_name = "realty"

    attr_accessible :name, :price, :address, :description

    #URL_FORMAT = /\A[\w+\-_]+\z/i

    validates :name, :price, :address, :description, :presence => true
    validates :name, :length => { :maximum => 100 }
    validates_numericality_of :price, :only_integer => true, :greater_than => 0

    default_scope :order => ['realty.created_at desc', 'realty.id desc']

    class << self

      def list(count = 5)
        self.limit(count).all
      end

    end
  end
end