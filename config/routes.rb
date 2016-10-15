Rails.application.routes.draw do
  resources :questions, only: [:show, :new, :create] do
    resources :answers, only: [:new, :create]
  end
end
