class PostsController < ApplicationController
	def index
	    @posts = Post.all
	    if params[:search]
	      @posts = Post.search(params[:search]).order("created_at DESC")
	    else
	      @posts = Post.all.order("created_at DESC")
	    end
    end
    def new
    	@post = Post.new
    end
    def create
    	if current_user
    		@post = Post.new post_params
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
    	@reply = Reply.new
    end

    private
    	def post_params
	      params.require(:post).permit(:title, :language, :body)
	    end
end
