Rails.application.routes.draw do
  devise_for :users

  root to: 'questions#index'

  resources :questions, only: [:index, :show, :new, :create] do
    resources :answers, only: [:create]
  end
end
