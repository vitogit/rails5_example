Rails.application.routes.draw do

  resources :user , only: [] do
    member do 
      post 'payment', to: 'users#payment'
    end 
  end

end
