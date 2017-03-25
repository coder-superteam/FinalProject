class VotesController < ApplicationController
	def create
		@vote = Vote.new(
			vote_action: params[:vote_action],
			vote_type: params[:vote_type],
			post_id: params[:post_id],
			user_id: params[:user_id],
			)
		if @vote.save
			'''
			vote_type:
				- 0: vote for Post
				- 1: vote for Reply
			'''
			if params[:vote_type] == 0.to_s
				@post = Post.find_by(id: params[:post_id])
				@post.vote_number = (@post.vote_number? ? @post.vote_number : 0) + params[:vote_action].to_i
				@post.save
			end
			redirect_to post_path(params['post_id'])
		end
	end

end
