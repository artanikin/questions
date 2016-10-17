Rails.application.routes.draw do
  resources :questions, only: [:index, :show, :new, :create] do
    resources :answers, only: [:create]
  end
end
