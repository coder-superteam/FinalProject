require 'ocr_space'

class OcrController < ApplicationController
	respond_to :html, :js

	def index
	end

	def get_text
		logger.debug('In GetText')
		image_url = params[:image]
		logger.debug('image_url = ' + image_url)
		logger.debug('OCR_SPACE_KEY = ' + ENV.fetch('OCR_SPACE_KEY'))
		resource = OcrSpace::Resource.new(apikey: ENV.fetch('OCR_SPACE_KEY'))
  		# result = resource.convert url: image_url.to_s
  		begin
  			@result = resource.clean_convert file: image_url
  		rescue
  			@result = 'Cannot convert to text'
  		end
  		logger.debug('result = ' + @result.to_s)


  		# logger.debug('result["FileParseExitCode"] = ' + result["FileParseExitCode"].to_s)
  		# if result["FileParseExitCode"].to_i == 1
  		# 	outputText = result['ParsedText']
  		# else 
  		# 	outputText = result['ErrorMessage']
  		# end

  		respond_to do |format|
	      format.js { render layout: false, content_type: 'text/javascript' }
	      format.html
	    end
  	end

  	private
  	def ocr_params
  		params.require(:image)
  	end
end
