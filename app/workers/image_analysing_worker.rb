require 'dotenv'
require 'aws-sdk'

class ImageAnalysingWorker
	include Sidekiq::Worker
  sidekiq_options :retry => 5

	def perform(*args)
        # Get image link and send to Amazon Rekognition
        # args[0]: @post
        post = Post.find(args[0].to_s)
        if !post.nil?
            client = Aws::Rekognition::Client.new(
               region: "us-east-1"
               )
            resp = client.detect_labels(
               image: { bytes: post.image.file.read }
               )
            logger.info('=====> resp = ' + resp.to_s)
            labels = resp.labels.map{|l| l.name}
            description = labels.to_s
            logger.info(description)
            post.keywords = description
            post.body = labels[0].gsub('"', '')
            post.save!

            if labels.any? { |x| ["Text", "Label", "Brochure", "Flyer", "Poster"].include?(x) }
                # Get text
                OcrWorker.perform_async(post.id)
            else
                # Send to translate worker queue
                TranslateWorker.perform_async(post.id)
            end
        end
    end
end
