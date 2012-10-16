module News
  class Entry < ActiveRecord::Base
    self.table_name = "news"

    attr_accessible :name, :date, :text, :category_id
    belongs_to :category, class_name: "News::Category"

    URL_FORMAT = /\A[\w+\-_]+\z/i

    validates :name, :date, :text, :presence => true
    validates :name, :length => { :maximum => 100 }

    default_scope :order => ['news.date desc', 'news.id desc']
    scope :by_category, ->(category) { where(:category_id => category) }

    class << self

      def list(count = 5)
        self.limit(count).all
      end

    end
  end
end
