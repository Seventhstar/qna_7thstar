Rails.application.routes.draw do
  
  use_doorkeeper

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end
    end
  end

  devise_scope :user do
    get 'sign_up', :to => 'devise/registrations#new'
    get 'sign_in', :to => 'devise/sessions#new'
    get 'sign_out', :to => 'devise/sessions#destroy'
  end
  
  concern :votes do
    member do
      post :vote_up
      post :vote_down
      post :reset
    end
  end

  concern :commentable do
    resources :comments, only: [:create]
  end

  resources :attachments, only: [:destroy,:index]
  resources :comments, only: [:update, :destroy] 

  devise_for :user, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  
  devise_scope :user do
    post '/register' => 'omniauth_callbacks#register'
  end
  
  get '/user/auth/:provider/callback', to: 'omniauth_callbacks#register'
  get '/auth/:provider/callback', to: 'omniauth_callbacks#register'
  
  resources :questions, concerns: [:votes, :commentable] do
    resources :answers, shallow: true, concerns: [:votes, :commentable] do
      patch :set_best, on: :member
    end
  end

  root to: 'questions#index'
  mount ActionCable.server => '/cable'

end
