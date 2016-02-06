Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      jsonapi_resources :exchanges
      jsonapi_resources :stocks
      jsonapi_resources :options
    end
  end
end
