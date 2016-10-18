Rails.application.routes.draw do
  devise_for :users

  root to: 'questions#index'

  resources :questions, except: [:edit, :update] do
    resources :answers, only: [:create]
  end
end
