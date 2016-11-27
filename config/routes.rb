Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks', confirmations: 'confirmations' }

  root to: "questions#index"

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
    end
  end

  concern :commentable do
    resources :comments, shallow: true
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, concerns: [:votable, :commentable], only: [:create, :destroy, :update], shallow: true do
      patch :best, on: :member
    end
  end

  resources :attachments, only: [:destroy]

  mount ActionCable.server => "/cable"
end
