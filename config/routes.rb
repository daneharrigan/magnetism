MagnetismCMS::Application.routes.draw do
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
      end
    end
  end

  match '/admin' => 'admin/dashboard#show', :as => :user_root
  match '/admin/logout' => 'admin/sessions#destroy', :as => :logout

  match '/(*path)' => 'dispatch#show'
end
