DevmenEngine::Application.routes.draw do

  # Realty module routes start
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
  # Realty module routes end

  # News module routes start
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
  # News module routes end

  scope module: 'contact_us' do
    resources :contact_us, only: [:new, :create], controller: "entries"
  end
  namespace :admin do
    scope module: "contact_us" do
      resources :contact_us, only: [:index, :show, :destroy], as: "contact_us_entry", controller: "entries"
    end
  end

  scope module: "sitemap" do
    resources :sitemap, only: [:index], controller: "entries"
  end

  resources :user_sessions, :only => [:new, :create, :destroy] 
  match '/signin',  :to => 'user_sessions#new'
  match '/signout', :to => 'user_sessions#destroy'

  resources :users, :only => [:index, :show]

  resources :pages, :only => [:index, :show]

  namespace :admin do    
    resources :users
    resources :pages, :except => [:index]    
    match '/elfinder', :to => 'base#elfinder'
    match '/', :to => 'base#index'
    # Handeling routing error for admin namespace, see below
    # match '*a', :to => 'base#index'
  end

  # Handeling routing error by error_controller
  # It must be a last route
  # IF your url was /this-url-does-not-exist, then params[:page] equals "/this-url-does-not-exist"
  match '*page', :to => 'pages#show'

  root :to => 'pages#index'
  
end
