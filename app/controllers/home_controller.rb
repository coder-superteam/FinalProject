class HomeController < ApplicationController
	skip_before_action :authenticate_user!, only: [:index]
	def index
		@last_10_posts = Post.limit(10).order("created_at desc").all
	end
end
