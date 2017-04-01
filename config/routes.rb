Rails.application.routes.draw do
	resources :rooms do
		resources :messages
	end

  post 'create_vote' => 'votes#create'
  get 'question_format' => 'posts#question_format'
	resources :posts do
  	resources :replies
  end
  get 'history' => 'posts#history'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  match "/users/:id/finish_signup", to: "users#finish_signup", via: [:get, :patch], as: :finish_signup
  mount ActionCable.server => '/cable'

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
