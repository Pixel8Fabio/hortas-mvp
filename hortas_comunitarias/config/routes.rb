Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  resources :gardens do
    collection do
      get :map
    end

    member do
      patch :submit_for_review
      patch :approve
      patch :reject
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end