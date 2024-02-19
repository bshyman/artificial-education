Rails.application.routes.draw do
  resources :players
  resources :users do
    patch 'update_xp', to: 'users#update_xp', on: :member
  end
  post 'change_player', to: 'application#change_player'
  resources :pokemon, except: :destroy do
    get 'new_question' => 'pokemon#new_question', on: :collection
  end
  resources :games, only: [:index] do
    get 'new_pokemon_round', to: 'rounds#pokemon_new'
    get 'new_simple_math_round', to: 'rounds#simple_math_new'
    resources :rounds, only: [] do
      get 'new_question', to: 'questions#new', on: :collection, as: 'new_question'
    end
  end

  resources :questions, only: [] do
    get 'new_simple_math', on: :collection
  end

  root to: 'games#index'

  get 'sign_in' => 'users#sign_in'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
end
