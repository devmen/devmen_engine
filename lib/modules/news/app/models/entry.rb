module News  
  class Entry < ActiveRecord::Base
    self.table_name = "news"

    attr_accessible :name, :date, :text
    
    URL_FORMAT = /\A[\w+\-_]+\z/i

    validates :name, :date, :text, :presence => true
    validates :name, :length => { :maximum => 100 }  

    default_scope :order => ['news.date desc', 'news.id desc']

    def teaser(options={})
      options = { :length => 150, :omission => '...' } if options.empty?
      helpers = ActionController::Base.helpers
      helpers.truncate(helpers.strip_tags(ApplicationHelper.to_html(self.text)).strip, options)
    end

    class << self

      def list(count = 5)
        self.limit(count).all
      end

    end
  end
end