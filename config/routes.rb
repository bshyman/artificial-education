Rails.application.routes.draw do
  resources :users
  resources :pokemon, except: :destroy
  resources :games, only: [:index] do
    get 'new_pokemon_round', to: 'rounds#pokemon_new'
    get 'new_simple_math_round', to: 'rounds#simple_math_new'
    resources :rounds, only: [] do
      get 'new_question', to: 'questions#new', on: :collection, as: 'new_question'
    end
  end
  root to: 'games#index'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
