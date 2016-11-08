Rails.application.routes.draw do
  devise_for :users

  root to: 'questions#index'

  resources :questions do
    resources :answers, shallow: true, only: [:create, :destroy, :update] do
      patch 'best', on: :member
    end
  end

  resources :attachments, only: [:destroy]
  post '/vote_up/:votable_type/:votable_id',   to: 'votes#up',   as: 'vote_up'
  post '/vote_down/:votable_type/:votable_id', to: 'votes#down', as: 'vote_down'
end
