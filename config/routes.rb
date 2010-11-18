MagnetismCMS::Application.routes.draw do
  namespace :admin do
    resource :session
    resources :users
    resources :pages
    resource :manage do
      resources :themes do
        resources :templates do
            resources :fields
        end
      end
    end
  end

  match '/admin' => 'admin/dashboard#show', :as => :dashboard
  match '/admin/logout' => 'admin/sessions#destroy', :as => :logout
end
