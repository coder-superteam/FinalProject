class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @posts = Post.all.order("created_at DESC")

    if params[:search]
      if params[:sort_by] == 1.to_s
        @posts = Post.search(params[:search]).order("vote_number DESC")
      else
        @posts = Post.search(params[:search]).order("created_at DESC")
      end
    end
  end

  def new
    if current_user
      if session[:post]
        @post = current_user.posts.new(session[:post])
        session[:post] = nil
        @post.valid? # run validations to to populate the errors[]
      else
        @post = Post.new title: 'Please help me translate: '
        # if params[:format]
        #   @post.title = params[:format]
        # else
        #   @post.title = 'Ask something else...'
        # end
      end
    else
      flash[:notice] = "You need to login first!"
      redirect_to new_user_session_path
    end
  end

  def create
    if current_user
      @post = Post.new post_params
      @post.language = 3
      @post.vote_number = 0
      @post.user_id = current_user.id
      if @post.save
        if @post.image.url.nil?
          TranslateWorker.perform_async(@post.id)
        else
          ImageAnalysingWorker.perform_async(@post.id)
        end
        # Redirect to user's post
        redirect_to post_path (@post)
      else
        session[:post] = @post
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
    @comment = Comment.new

  end

  def history
    'Find all histories belong to user'
    @posts = Post.where(:user_id => current_user.id).order("updated_at DESC, vote_number DESC")
  end

  def question_format
  end

  private

  def post_params
    params.require(:post).permit(:title, :language, :body, :image)
  end
end