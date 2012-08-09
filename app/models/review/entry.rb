class Review::Entry < ActiveRecord::Base
  attr_accessible :content, :name, :visible

  validates :name, :content, presence: true

  default_scope order: ['review_entries.created_at DESC']
  scope :visible, -> { where(visible: true) }
end
