MagnetismCMS::Application.routes.draw do
  namespace :admin do
    resource :session
    resources :users
    resources :pages
    resource :manage do
      resources :themes do
        resources :templates
      end
    end
  end

  match '/admin' => 'admin/dashboard#show', :as => :dashboard
  match '/admin/logout' => 'admin/sessions#destroy', :as => :logout

  # debugger

  # match '/admin/sessions/new' => 'admin/users#new', :as => 'sign_up'
  # match 'sign_in'  => 'clearance/sessions#new', :as => :sign_in
  # match 'sign_out' => 'clearance/sessions#destroy', :via => :delete, :as => 'sign_out'
end
