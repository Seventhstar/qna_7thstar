Rails.application.routes.draw do

  get 'votes/create'

  get 'votes/reset'

  devise_scope :user do
    get 'sign_up', :to => 'devise/registrations#new'
    get 'sign_in', :to => 'devise/sessions#new'
    get 'sign_out', :to => 'devise/sessions#destroy'
  end

  resources :attachments, only: [:destroy,:index]

  devise_for :user
  resources :questions do
    resources :answers, shallow: true do
      patch :set_best, on: :member
    end
  end

  resources :votes, only: [:create] do
    delete :reset, on: :collection
  end

  root to: 'questions#index'

end
