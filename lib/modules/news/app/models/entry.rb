module News  
  class Entry < ActiveRecord::Base
    self.table_name = "news"

    attr_accessible :name, :date, :text
    
    URL_FORMAT = /\A[\w+\-_]+\z/i

    validates :name, :date, :text, :presence => true
    validates :name, :length => { :maximum => 100 }  

    default_scope :order => ['news.date desc', 'news.id desc']

    class << self

      def list(count = 5)
        self.limit(count).all
      end

    end
  end
end