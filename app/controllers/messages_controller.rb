class MessagesController < ApplicationController
	before_action :set_room
	def index
		@messages = Message.where(room_id: params[:room_id])
	end

	def new 
		@message = Message.new
	end

	def create	
		unless current_user
			redirect_to "new_user_session_path"
		end	
		@message = @room.messages.build message_params
		@message.user = current_user
		unless @message.save
			flash[:error] = "Error #{@message.errors.full_messages.to_sentence}"
		end
		redirect_back fallback_location: { action: "index", id: @room.id}
	end

	private

	def set_room
		@room = Room.find_by_id(params[:room_id])
	end
	def message_params
		params.require(:message).permit(:body, :room_id)
	end
end
