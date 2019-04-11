Rails.application.routes.draw do

  resources :user , only: [] do
    member do 
      post 'payment', to: 'users#payment'
      post 'balance', to: 'users#balance'
    end 
  end

end
