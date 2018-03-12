Rails.application.routes.draw do

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

  resources :attachments, only: [:destroy,:index]

  resources :comments, only: [:update, :destroy] 

  devise_for :user
  resources :questions, concerns: [:votes] do
    resources :comments, only: [:create]
    resources :answers, shallow: true, concerns: [:votes] do
      resources :comments, only: [:create]
      patch :set_best, on: :member
    end
  end

  root to: 'questions#index'
  mount ActionCable.server => '/cable'

end
