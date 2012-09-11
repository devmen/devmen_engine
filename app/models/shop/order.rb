class Shop::Order < ActiveRecord::Base
  attr_accessible :name, :email, :address

  has_many :product_items, dependent: :destroy, inverse_of: :order

  validates :name, :email, :address, :presence => true
  validates_format_of :email, :with => %r{\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z}i

  after_create :generate_uniq_number

  def add (items)
    items.each {|item| product_items << item }
    product_items
  end

  private

    def generate_uniq_number # Use algorithm with base number and xor it with id
      update_column(:num, convert_number(base_number, self.id))
    end

    def base_number # use digits from secret_token
      magic = Rails.application.config.secret_token.gsub(/[^\d]+/, '').sub(/^0+/, '').to_i
      base = []
      29.downto(0) { |i| base << magic[i] } # use only 30 bits
      base.join.to_i(2)
    end

    def convert_number(base, number, back = nil)
      n = 0
      if back != :back
        0.upto(29) { |i| n = n << 1 | number[i] }
        n = n ^ base
      else
        x = number ^ base
        0.upto(29) { |i| n = n << 1 | x[i] }
      end
      n
    end

end
