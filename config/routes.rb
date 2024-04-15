Rails.application.routes.draw do
  resources :groups
  resources :players
  resources :users, except: :show do
    patch 'update_xp', to: 'users#update_xp', on: :member
  end
  post 'change_player', to: 'application#change_player'
  resources :pokemon, except: :destroy do
    get 'new_question' => 'pokemon#new_question', on: :collection
    get 'pokedex', on: :collection
  end
  resources :games, only: [:index] do
    get 'new_pokemon_round', to: 'rounds#pokemon_new'
    get 'new_simple_math_round', to: 'rounds#simple_math_new'
    get 'new_collections_round', to: 'rounds#collections_new'
    get 'trivia', to: 'rounds#trivia'
    resources :rounds, only: [] do
      get 'new_question', to: 'questions#new', on: :collection, as: 'new_question'
    end
  end

  resources :questions, except: [:create] do
    member do
      get 'edit_trivia', to: 'trivia_questions#edit', as: 'edit_trivia'
      delete 'trivia', to: 'trivia_questions#destroy'
    end
    post 'trivia_questions', to: 'trivia_questions#create', as: 'create_trivia', on: :collection
    get 'trivia', to: 'questions#trivia_questions', as: 'trivia', on: :collection
  end
  # get 'new_trivia_question', to: 'questions#new_trivia_question', as: 'new_trivia_question'
  # post

  resources :questions, only: [] do
    get 'new_simple_math', on: :collection
  end

  root to: 'games#index'

  get 'sign_in' => 'users#sign_in'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
end
