DevmenEngine::Application.routes.draw do

  # Shop module routes start
  scope :module => 'shop', :path => "shop" do
    resources :products, :only => [:index, :show], as: "products"
    resources :categories, :only => [:index, :show], as: "product_categories"
    resource :cart, :only => [:show, :update], as: "cart"
    resources :product_items, :only => [:create], as: "product_items"
    resource :order, :only => [:new, :create], as: "order"
  end
  namespace :admin do
    scope :module => 'shop' do
      resources :products
      resources :product_categories, as: "product_categories", controller: "categories"
    end
  end
  # Shop module routes end

  # Realty module routes start
  scope :module => 'realty' do
    resources :realty, :only => [:index, :show], :controller => 'entries'
  end
  namespace :admin do
    scope :module => 'realty' do
      resources :realty, :except => [:index, :create], :as => 'realty_entry', :controller => 'entries'
      resources :realty_categories, as: "realty_categories", controller: "categories"
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
      resources :news_categories, as: "news_categories", controller: "categories"
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

  scope module: "reviews" do
    resources :reviews, only: [:index, :new, :create], controller: "entries"
  end
  namespace :admin do
    scope module: "reviews" do
      resources :reviews, only: [:index, :show, :destroy], as: "reviews", controller: "entries" do
        post :visible, on: :member
      end
    end
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
