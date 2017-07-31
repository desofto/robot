Rails.application.routes.draw do
  root to: 'home#index'

  mount API::Root => '/api/'
end
