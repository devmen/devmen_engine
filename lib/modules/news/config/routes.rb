scope :module => 'news' do
  resources :news, :only => [:index, :show], :controller => 'entries'
end
namespace :admin do
  scope :module => 'news' do
    resources :news, :except => [:index, :create], :as => 'news_entry', :controller => 'entries'
    match 'news', :to => 'entries#index', :as => 'news', :via => :get
    match 'news', :to => 'entries#create', :as => 'news', :via => :post
  end
end