Rails.application.routes.draw do

  resources :user , only: [] do
    member do 
      post 'payment', to: 'users#payment'
      get 'balance', to: 'users#balance'
      get 'feed', to: 'users#feed'
    end 
  end

end
