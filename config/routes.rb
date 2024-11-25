Rails.application.routes.draw do
  get "welcome/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "welcome#index"
  namespace :api do
    namespace :v1 do
      resources :clients, only: [:index] do
        resources :buildings, only: [:create]
        resources :custom_fields, only: [:index]
      end

      resources :buildings, only: [:index, :update, :show]
    end
  end

  get '*path', to: 'welcome#index', constraints: ->(req) { req.format.html? }
end
