Rails.application.routes.draw do
  devise_for :users

  root to: "questions#index"

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
    end
  end

  concern :commentable do
    resources :comments, shallow: true, only: [:create]
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, concerns: [:votable, :commentable], shallow: true, only: [:create, :destroy, :update] do
      patch "best", on: :member
    end
  end

  resources :attachments, only: [:destroy]

  mount ActionCable.server => "/cable"
end
