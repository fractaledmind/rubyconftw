Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :sessions, only: [:new, :create]

  constraints(AuthenticatedConstraint.new) do
    resource :user, only: %i[ show edit new create update destroy ]
    resources :sessions, only: [:index, :new, :destroy]

    resources :posts do
      resources :comments, shallow: true
    end

    root to: "users#show", as: :user_root
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root to: "sessions#new"
end
