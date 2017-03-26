Rails.application.routes.draw do
	
  get 'recognition/index'

  get 'ocr/index'
  post 'ocr/get_text' => "ocr#getText"

  get 'translators/index'

	resources :rooms do
		resources :messages
	end

	resources :posts do
  	resources :replies
  end
  root 'home#index'
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  match "/users/:id/finish_signup", to: "users#finish_signup", via: [:get, :patch], as: :finish_signup
  mount ActionCable.server => '/cable'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
