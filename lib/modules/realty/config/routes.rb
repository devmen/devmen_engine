scope :module => 'realty' do
  resources :realty, :only => [:index, :show], :controller => 'entries'
end
namespace :admin do
  scope :module => 'realty' do
    resources :realty, :except => [:index, :create], :as => 'realty_entry', :controller => 'entries'
    match 'realty', :to => 'entries#index', :as => 'realty', :via => :get
    match 'realty', :to => 'entries#create', :as => 'realty', :via => :post
  end
end