require 'ocr_space'

class OcrController < ApplicationController
	def index
	end

	def getText
		logger.debug('In GetText')
		image_url = '"' + params[:image] + '"'
		logger.debug('image_url = ' + image_url)
		logger.debug('OCR_SPACE_KEY = ' + ENV.fetch('OCR_SPACE_KEY'))
		resource = OcrSpace::Resource.new(apikey: ENV.fetch('OCR_SPACE_KEY'))
  		result = resource.convert url: image_url.to_s
  	# result = resource.convert file: "/Users/hnanhquoc/Desktop/Myriad-Apple-TextA.png"
  		logger.debug('result = ' + result.to_s)
  	if result['FileParseExitCode'].to_i == 1
  		puts result['ParsedText']
  	else 
  		puts result['ErrorMessage']
  	end
  end

  private
  def ocr_params
  	params.require(:image)
  end
end
