Rails.application.routes.draw do
  resources :comments
	resources :rooms do
		resources :messages
	end
  resources :media_contents, only: [:create]
  post 'create_vote' => 'votes#create'
  get 'question_format' => 'posts#question_format'
	resources :posts do
  	resources :replies
  end

  resources :replies do
    resources :comments
  end

  resources :posts do
    resources :comments
  end
  get 'history' => 'posts#history'
  post 'post_commends' => 'commends#create'
  post 'reply_commends' => 'commends#create'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  match "/users/:id/finish_signup", to: "users#finish_signup", via: [:get, :patch], as: :finish_signup
  mount ActionCable.server => '/cable'

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
