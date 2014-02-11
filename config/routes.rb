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
  
  # Home Screen Paths
  match '/home', to: 'menus#home', via:'get'

  # Sessions and Users creation Paths
  match '/signin', to: 'sessions#new', via: 'get'
  match '/signup', to: 'users#new', via: 'get'
  match '/signout', to: 'sessions#destroy', via: 'get'
  
  # Object Repository Paths
  match '/obj_repo', to: 'object_repositories#index', via: 'get'
  
  # Configuration Paths
  match '/configuration', to: 'selenium_configs#index', via: 'get'
  
  # Test Suite Paths
  match '/exec_test', to: 'test_suites#exec_test', via: 'get'
  match '/add_tc_to_queue', to: 'test_suites#add_tc', via: 'get'

  # Test Paths
  match '/exec_test_step' , to: 'tests#exec_test_step', via: 'get'
  match '/add_ts_to_queue', to: 'tests#add_ts', via: 'get'

  # Test Step Paths
  match '/update_pages', to: 'test_steps#update_pages', via: 'get'
  match '/update_elements', to: 'test_steps#update_elements', via: 'get'
  match '/update_function', to: 'test_steps#update_function', via: 'get'

  # Queue Paths
  match '/queue', to: 'queue_cart#index', via: 'get'
  match '/queue/show', to: 'queue_cart#show', via: 'get'
  match '/queue/view_report', to: 'queue_cart#view_report', via: 'get'
  match '/queue/show_report', to: 'queue_cart#show_report', via: 'get'
  #match '/queue/exec_all', to: 'queue_cart#exec_all', via: 'get'
  match '/queue/exec_sel', to: 'queue_cart#exec_sel', via: 'post'
  match '/queue', to: 'queue_cart#destroy', via: 'delete'

  # Sidekiq Dashboard Path
  mount Sidekiq::Web, at: '/sidekiq'
end
