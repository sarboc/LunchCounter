LunchCounter::Application.routes.draw do
  root to: "places#index"
  get "/:id", to: "places#show"
  get "/:id/new", to: "places#new", as: "new_place"
  post "/places", to: "places#create"
  #resources :places, except: [:index]
  # get "/:search", to: "places#index"

end
