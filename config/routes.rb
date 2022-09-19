Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  get '/services', to: 'services#index'
  get '/service/new', to: 'services#new'
  post '/service', to: 'services#create'
  get '/requests', to: 'drivers#index'
  patch '/requests/:id', to: 'drivers#update_request_status'
  get '/tickets', to: 'passengers#index_tickets'
  post '/ticket', to: 'passengers#create_ticket' 
  get '/vehicles', to: 'vehicles#index'
  post '/vehicle', to: 'vehicles#create_vehicle'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
