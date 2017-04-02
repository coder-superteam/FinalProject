require 'dotenv'
require 'google/apis/translate_v2'

class TranslateWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 5

  def perform(*args)
    post = Post.find(args[0].to_s)
    if !post.nil? && !post.body.blank?
    	translate = Google::Apis::TranslateV2::TranslateService.new
        translate.key = ENV.fetch('GG_API_KEY')
        result = translate.list_translations(post.body, 'vi', source: 'en')
        logger.info(result.translations.first.translated_text)

        # Create a reply
        @reply = Reply.new body: result.translations.first.translated_text
        @reply.user_id = User.find_by_email('googlebot@admin.com').id
        @reply.post_id = post.id
        @reply.vote_number = 0

        @reply.save
    end
  end
end
