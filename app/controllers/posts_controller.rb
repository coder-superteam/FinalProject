class PostsController < ApplicationController
    skip_before_action :authenticate_user!, only: [:index, :show]
	def index
	    @posts = Post.all
	    if params[:search]
            if params[:sort_by] == 1.to_s
                @posts = Post.search(params[:search]).order("vote_number DESC").where(language: params['filter_by'])
            else
                @posts = Post.search(params[:search]).order("created_at DESC").where(language: params['filter_by'])
            end
	    else
	      @posts = Post.all.order("created_at DESC")
	    end
    end

    def new()
    	@post = Post.new
        @title = params[:format]
    end

    def create

    	if current_user
    		@post = Post.new post_params
            @post.vote_number = 0
    		@post.user_id = current_user.id
    		if @post.save
    			flash[:success] = "Message created success"
					redirect_to post_path (@post)
    		else
    			render 'new'
    		end
    	else
    		flash[:notice] = "You need to login first!"
    		redirect_to new_user_session_path
    	end
    end

    def show
    	@post = Post.find_by(id: params['id'])
        @voted = 0
        if current_user
            @voted = Post.voted(current_user.id, @post.id)
        end
    	@reply = Reply.new

    end

    def history
        'Find all histories belong to user'
        @posts = Post.where(:user_id => current_user.id)
    end

    def question_format
    end

    private
    	def post_params
	      params.require(:post).permit(:title, :language, :body, :image)
	    end
end
