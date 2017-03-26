class VotesController < ApplicationController
	def create

		#skip_before_action :authenticate_user!
		@vote = Vote.new



		if params[:vote_type] == 0.to_s
			@vote = Vote.new(
				vote_action: params[:vote_action],
				vote_type: params[:vote_type],
				post_id: params[:post_id],
				user_id: current_user.id,
				)
		else
			@vote = Vote.new(
				vote_action: params[:vote_action],
				vote_type: params[:vote_type],
				reply_id: params[:reply_id],
				user_id: current_user.id,
				)
		end

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
			else
				@reply = Reply.find_by(id: params[:reply_id])
				@reply.vote_number = (@reply.vote_number? ? @reply.vote_number : 0) + params[:vote_action].to_i
				@reply.save
			end
			redirect_to post_path(params[:post_id])
		end
	end

end
