require 'sidekiq/web'

APA::Application.routes.draw do

  resources :selenium_configs

  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :object_repositories do
    resources :web_elements
  end
  resources :test_suites do
    resources :tests       
  end
  resources :tests do
    resources :test_steps
  end
  root 'menus#welcome'
  match '/signin', to: 'sessions#new', via: 'get'
  match '/signup', to: 'users#new', via: 'get'
  match '/signout', to: 'sessions#destroy', via: 'get'
  match '/or', to: 'object_repositories#index', via: 'get'
  match '/home', to: 'menus#home', via:'get'
  match '/configuration', to: 'selenium_configs#index', via: 'get'
  match '/exec_test', to: 'test_suites#exec_test', via: 'get'
  match '/exec_test_step' , to: 'tests#exec_test_step', via: 'get'
  match '/update_pages', to: 'test_steps#update_pages', via: 'get'
  match '/update_elements', to: 'test_steps#update_elements', via: 'get'
  match '/update_function', to: 'test_steps#update_function', via: 'get'
  
  match '/report', to:'report#index', via:'get'
  match '/report/view', to: 'report#view', via: 'get'
  match '/report/show', to: 'report#show', via: 'get'
  mount Sidekiq::Web, at: '/sidekiq'
end
