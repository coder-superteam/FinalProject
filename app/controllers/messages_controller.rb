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
		@message.save!
		# let's broadcast message html to all the clients
		ActionCable.server.broadcast 'messages', message: render_message(@message)
		head :ok
	end

	private
	def render_message(message)
	    ApplicationController.render partial: 'messages/message', locals: {message: message}
	end
	def set_room
		@room = Room.find_by_id(params[:room_id])
	end
	def message_params
		params.require(:message).permit(:body, :room_id)
	end
end
