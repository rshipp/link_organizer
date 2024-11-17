Rails.application.routes.draw do
  passwordless_for :users

  ### Admin users
  constraints Passwordless::Constraint.new(User, if: -> (user) { user.admin }) do
    resources :links, only: [:destroy]
    resources :tags, only: [:destroy]
    resources :queued_links, only: [:index, :show, :destroy] do
      post :apply, to: 'queued_links#apply', on: :member
    end
  end

  ### Logged-in users
  constraints Passwordless::Constraint.new(User) do
    resources :tags, only: [:new, :create, :update, :edit]
    resources :links, only: [:new, :create, :update, :edit] do
      get :import, to: 'links#import_new', on: :collection
      post :import, to: 'links#import_create', on: :collection
      post :import, to: 'links#run_import', on: :member
      get :unprocessed, to: 'links#unprocessed', on: :collection
    end
    # combobox
    post "possibly_new_tag_chips", to: "tag_chips#create_possibly_new"
  end

  ### Anonymous users
  resources :tags, only: [:index, :show]
  resources :links, only: [:index, :show]
  get :advanced_search, to: 'home#advanced_search'
  get :advanced_search_results, to: 'home#advanced_search_results'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
end
