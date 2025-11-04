# frozen_string_literal: true

Rails.application.routes.draw do
  resources :answers
  get 'inertia-example', to: 'inertia_example#index'
  resources :user_prizes, only: [:index, :create]
  resources :prizes
  resources :groups
  resources :players
  resources :users, except: :show do
    patch 'update_xp', to: 'users#update_xp', on: :collection
    post 'authenticate', to: 'users#authenticate', on: :member
  end

  resources :tasks do
    post 'complete', on: :member
  end

  post 'switch_user', to: 'application#switch_user'
  resources :pokemon, except: :destroy do
    get 'new_question' => 'pokemon#new_question', on: :collection
    post 'create_round' => 'pokemon#create_round', on: :collection
    post 'submit_answer' => 'pokemon#submit_answer', on: :collection
    get 'pokedex', on: :collection
  end

  get 'store', to: 'home#store'

  resources :games do
    get 'new_pokemon_round', to: 'rounds#pokemon_new'
    get 'new_simple_math_round', to: 'rounds#simple_math_new'
    get 'new_collections_round', to: 'rounds#collections_new'
    get 'trivia', to: 'rounds#trivia'
    get 'state_selector', to: 'rounds#state_selector'
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

  get 'state_selector', to: 'rounds#state_selector'

  root to: 'games#index'
  get 'landing' => 'home#landing'

  get 'sign_in' => 'users#sign_in'
  get '/auth/auth0/callback' => 'auth0#callback'
  get '/auth/failure' => 'auth0#failure'
  get '/auth/logout' => 'auth0#logout', as: 'logout'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
end
