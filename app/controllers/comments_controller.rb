class CommentsController < ApplicationController
	#skip_before_action :authenticate_user!, only: [:index, :show]
	def new
		@comment = Comment.new
	end

	def create
		@comment = Comment.new comment_params
		@comment.user_id = current_user.id
		if params[:post_id]
			@comment.post_id = params[:post_id]
			@post_id = params[:post_id]
		else
			@comment.reply_id = params[:reply_id]
			@reply = Reply.find_by(id: params[:reply_id])
			@post_id = @reply.post_id
		end
		# @comment.like_number = 0

		if @comment.save
			flash[:success] = "Comment created success"
		end
		redirect_to post_path (@post_id)
	end

	private
		def comment_params
			params.require(:comment).permit(:body)
		end
end
