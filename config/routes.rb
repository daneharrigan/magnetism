Rails.application.routes.draw do
  devise_for :users, :path => 'admin',
    :path_names => { :sign_in => 'login', :sign_out => 'logout' },
    :controllers => { :sessions => 'admin/sessions' }

  namespace :admin do
    resource :session
    resources :pages
    resources :assets
    resource :manage do
      resources :users
      resources :sites
      resources :themes do
        resources :templates do
          resources :fields
        end
        resources :template_sets
      end
    end
  end

  # admin routes
  match '/admin' => 'admin/dashboard#show', :as => :user_root
  match '/admin/logout' => 'admin/sessions#destroy', :as => :logout
  match '/admin/:directory/*file_name.:format' => 'admin/support_files#show', :constraints => { :directory => /(stylesheets|javascripts|images)/}

  # public routes
  match '/assets/:site_key/:directory/:file_name' => 'assets#show'
  match '/(*path)/feed.:format' => 'feeds#show'
  match '/(*path)' => 'dispatch#show', :via => [:get, :post]
end
