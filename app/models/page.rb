class Page < ActiveRecord::Base
  attr_accessible :body, :name, :url
  
  URL_FORMAT = /\A[\w+\-_]+\z/i

  validates :name, :presence => true, :length => { :maximum => 100 }
  validates :url, :allow_blank => true, :format => { :with => URL_FORMAT },
						:uniqueness => { :case_sensitive => false }

  default_scope :order => 'pages.name'

  before_save :check_url

  def to_param
    url
  end

  private

    def check_url
      # Russian module add transliteration to parameterize method of strings
      self.url = self.name.parameterize if self.url.blank?
    end

  class << self
    
    def url?(string)
      string =~ URL_FORMAT
    end

  end

end
