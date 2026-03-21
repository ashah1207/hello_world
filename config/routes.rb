Rails.application.routes.draw do
  root 'markets#index'

  resource :session, only: [:new, :create, :destroy]

  resources :markets, only: [:index, :show, :new, :create] do
    resources :bets, only: [:create]
    member do
      post :settle
      post :report
    end
  end

  resources :pools, only: [:index, :show, :new, :create] do
    member do
      post :join
      delete :leave
    end
  end

  get  '/leaderboard', to: 'leaderboard#index', as: :leaderboard
  get  '/wallet',      to: 'wallets#show',       as: :wallet
  post '/wallet/deposit', to: 'wallets#deposit', as: :wallet_deposit
  post '/blacklist',   to: 'users#blacklist',    as: :blacklist
  post '/toggle_anonymous', to: 'users#toggle_anonymous', as: :toggle_anonymous
end
