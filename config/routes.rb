Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  devise_for :admins, controllers: {
    sessions: 'admin/devise/sessions'
  }

  namespace :admin do
    root 'welcome#index'
    resources :intentions, only: [:index, :new, :create, :edit, :update, :destroy] do
      member { post :publish }
      member { post :reject }
    end

    resources :admins, only: [:index, :new, :create, :destroy] do
      collection { get :new_invitation }
      collection { post :invite }
    end

    get 'confirm/:token', to: 'admin#confirm', as: 'confirm'
  end

  # You can have the root of your site routed with "root"
  root 'welcome#index'
end
