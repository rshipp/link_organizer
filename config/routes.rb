Rails.application.routes.draw do
  resources :tags
  resources :links do
    get :import, to: 'links#import_new', on: :collection
    post :import, to: 'links#import_create', on: :collection
    post :import, to: 'links#run_import', on: :member
    get :unprocessed, to: 'links#unprocessed', on: :collection
  end

  # combobox
  post "possibly_new_tag_chips", to: "tag_chips#create_possibly_new"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
end
