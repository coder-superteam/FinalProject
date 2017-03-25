require 'google/api_client'

class HomeController < ApplicationController
	skip_before_action :authenticate_user!, only: [:index]
	def index
		client = Google::APIClient.new(:key => YOUR_DEVELOPER_KEY)
		translate = client.discovered_api('translate', 'v2')
		result = client.execute(
			:api_method => translate.translations.list,
			:parameters => {
				'format' => 'text',
				'source' => 'en',
				'target' => 'es',
				'q' => 'The quick brown fox jumped over the lazy dog.'
			}
			)
		raise result
	end
end
