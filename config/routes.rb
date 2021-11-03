Rails.application.routes.draw do
  root 'home#index'
  post '/check', controller: 'check', action: 'upload'
  post '/game', controller: 'game', action: 'start'
end
