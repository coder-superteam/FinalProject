require 'dotenv'
require 'ocr_space'

class OcrWorker
	include Sidekiq::Worker
    sidekiq_options :retry => 5

	def perform(*args)
        # Get text from image
        # args[0]: @post
        post = Post.find(args[0].to_s)
        if !post.nil?
        	resource = OcrSpace::Resource.new(apikey: ENV.fetch('OCR_SPACE_KEY'))
        	# begin
                logger.info(post.image.file.file)
        		result = resource.clean_convert file: post.image.file.file
                # Put description
                if !result.nil? && !post.keywords.nil?
        		  post.keywords = post.keywords + '[' + result + "]" 
                end
        	# rescue
        	# 	result = 'Cannot convert to text'
        	# end
        	logger.info('result = ' + result.to_s)

            if !result.nil? && result != 'Cannot convert to text'
            	post.body = result
            end

            post.save!
            TranslateWorker.perform_async(post.id) if !post.body.blank?
        end
    end
end
