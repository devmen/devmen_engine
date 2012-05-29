class Page < ActiveRecord::Base
  attr_accessible :body, :name, :url
  
  url_regex = /\A[\w+\-_]+\z/i

  validates :name, :presence => true, :length => { :maximum => 100 }
  validates :url, :presence => true,
  					:format => { :with => url_regex },
						:uniqueness => { :case_sensitive => false }

  default_scope :order => 'pages.name'

  before_save :check_url

  private

    def check_url
      # Russian module add transliteration to parameterize method of strings
      self.url = self.name.parameterize if self.url.blank?
    end

end
