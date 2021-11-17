Rails.application.routes.draw do
  root 'game#index'
  post '/upload', controller: 'game', action: 'upload'
  post '/game', controller: 'game', action: 'start'
  post '/stop', controller: 'game', action: 'stop'
end
