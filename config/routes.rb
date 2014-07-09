RedditClone::Application.routes.draw do
  resources :users
  resource :session


  resources :subs do
    resources :posts, shallow: true do
      resources :comments, only: [:new]
      resource :vote, only: [:create]
    end
  end

  resources :comments, only: [:create] do
    resources :comments, only: [:new]
    resource :vote, only: [:create]
  end


  root to: "subs#index"

end
