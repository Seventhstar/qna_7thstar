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

  devise_for :user
  resources :questions, concerns: [:votes] do
    resources :answers, shallow: true, concerns: [:votes] do
      patch :set_best, on: :member
    end
  end



  root to: 'questions#index'

end
