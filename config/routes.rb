Rails.application.routes.draw do
  devise_scope :user do
    get 'sign_up', :to => 'devise/registrations#new'
    get 'sign_in', :to => 'devise/sessions#new'
    get 'sign_out', :to => 'devise/sessions#destroy'
  end
  devise_for :user
  resources :questions do
    resources :answers, shallow: true
  end

  root to: 'questions#index'
end
