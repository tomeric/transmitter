Operator::Application.routes.draw do
  root :to => 'applications#index'

  resources :applications do
    resources :notifiers  
  end

  resources :notifications
end
