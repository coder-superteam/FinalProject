require 'google/apis/translate_v2'

class TranslatorsController < ApplicationController
	def index
	end

	def ggtranslate
		if params[:content]
			translate = Google::Apis::TranslateV2::TranslateService.new
			translate.key = ENV.fetch('GG_API_KEY')
			result = translate.list_translations(params[:content], 'vi', source: 'en')
			puts result.translations.first.translated_text
		end
		
	end

	private

	def translators_params
		params.require(:content)
	end
end
