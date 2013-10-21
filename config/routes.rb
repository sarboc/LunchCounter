LunchCounter::Application.routes.draw do
  root to: "places#index"
  get "/:id", to: "places#show"
  #resources :places, except: [:index]
  # get "/:search", to: "places#index"

end
