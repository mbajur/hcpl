Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'posts#now'

  get :week, to: 'posts#week', as: :posts_popular_this_week
  get :month, to: 'posts#month', as: :posts_popular_this_month
  get :year, to: 'posts#year', as: :posts_popular_this_year
  get :new, to: 'posts#recent', as: :new
  get :saved, to: 'posts#saved', as: :saved
  get :search, to: 'posts#search', as: :search
  get :add, to: 'posts#new', as: :new_post
  post :add, to: 'posts#create', as: :create_post
  get :events, to: 'events#index', as: :events
  get 'events/past', to: 'events#past', as: :past_events

  get 't/:slug', to: 'tags#show', as: :tag
  get 'p/:token/:slug', to: 'posts#show', as: :post
  get '@:username', to: 'users#show', as: :user

  get 'auth/sign_in', to: 'auth#sign_in', as: :sign_in
  delete 'auth/sign_out', to: 'auth#sign_out', as: :sign_out
  get 'auth/comeback', to: 'auth#comeback', as: :sign_in_comeback

  resources :comments, only: [:create]

  namespace :api do
    namespace :internal do
      namespace :v1 do
        resources :tags, only: [:index]
        resource :posts do
          post ':token/toggle_vote', action: :toggle_vote
          post ':token/toggle_bookmark', action: :toggle_bookmark
          post :fetch_title, on: :collection
        end
      end
    end
  end
end
