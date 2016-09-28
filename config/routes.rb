Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  namespace :admin do
    root 'welcome#index'
    resources :intentions, only: [:index, :new, :create, :edit, :update]
  end

  # You can have the root of your site routed with "root"
  root 'admin/welcome#index'
end
