require 'ocr_space'
require 'dotenv'
require 'aws-sdk'
require 'google/apis/translate_v2'

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
              @post = Post.new title: 'Please help me translate this'
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
                unless @post.image.nil?
                    # Get image link and send to Amazon Rekognition
                   client = Aws::Rekognition::Client.new(
                     region: "us-east-1"
                     )
                   resp = client.detect_labels(
                       image: { bytes: @post.image.file.read }
                       )
                   logger.info('=====> resp = ' + resp.to_s)
                   resp.labels.each do |label|
                        puts "#{label.name}-#{label.confidence.to_i}"
                    end
                    labels = resp.labels.map{|l| l.name}
                    description = labels.to_s
                    logger.info(description)
                    #  Get text
                    if labels.include? 'Text' || 'Label'
                        resource = OcrSpace::Resource.new(apikey: ENV.fetch('OCR_SPACE_KEY'))
                        begin
                            result = resource.clean_convert file: @post.image.file.file
                            description = description + '[' + result + "]"
                        rescue
                            result = 'Cannot convert to text'
                        end
                        logger.debug('result = ' + result)
                    end
                    # Put description
                    @post.keywords = description
                    @post.save!
                    # Call translate
                    if result != 'Cannot convert to text'
                        translate = Google::Apis::TranslateV2::TranslateService.new
                        translate.key = ENV.fetch('GG_API_KEY')
                        result = translate.list_translations(result, 'vi', source: 'en')
                        puts result.translations.first.translated_text

                        # Create a reply
                        @reply = Reply.new body: result.translations.first.translated_text
                        @reply.user_id = User.find_by_email('googlebot@admin.com').id
                        @reply.post_id = @post.id
                        @reply.vote_number = 0

                        @reply.save
                    end
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