Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :sessions, only: %i[ new create ]
  resources :users, only: %i[ show new create ]
  get '/sign_in', to: 'sessions#new', as: :sign_in
  get '/sign_up', to: 'users#new', as: :sign_up

  constraints(AuthenticatedConstraint.new) do
    resource :user, only: %i[ edit update destroy ]
    resources :sessions, only: %i[ destroy ]
    resources :posts, only: %i[ new create edit update destroy ] do
      resources :comments, only: %i[ new create edit update destroy ], shallow: true
    end
  end

  resources :posts, only: %i[ index show ]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  post "benchmarking/read_heavy" => "benchmarking#read_heavy"
  post "benchmarking/write_heavy" => "benchmarking#write_heavy"
  post "benchmarking/balanced" => "benchmarking#balanced"

  # Defines the root path route ("/")
  root to: "posts#index"
end
