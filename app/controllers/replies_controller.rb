class RepliesController < ApplicationController
	def new
		@reply = Reply.new
	end

	def index
		@post = Post.find_by(id: params['post_id'])
		@replies = @post.replies
		
		respond_to do |format|
			format.html
		end
	end

	def create
		if current_user
  		@reply = Reply.new reply_params
  		@reply.user_id = current_user.id
  		@reply.post_id = params[:post_id]
  		@reply.vote_number = 0

  		if @reply.save
  			# flash[:success] = "Message created success"
  		end
  		redirect_to post_path (params[:post_id]) 
    else
  		flash[:notice] = "You need to login first!"
  		redirect_to new_user_session_path
    end
	end

	private
		def reply_params
			params.require(:reply).permit(:body)
		end
end
