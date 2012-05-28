class Page < ActiveRecord::Base
  attr_accessible :body, :name, :url
  
  url_regex = /\A[\w+\-_]+\z/i

  validates :name, :presence => true, :length => { :maximum => 100 }
  validates :url, :presence => true,
  					:format => { :with => url_regex },
						:uniqueness => { :case_sensitive => false }

  default_scope :order => 'pages.name'

end
