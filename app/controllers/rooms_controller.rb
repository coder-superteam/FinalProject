class RoomsController < ApplicationController
	def index
		@rooms = Room.all.order(created_at: :desc)
	end
  def create
  	@room = Room.new room_params
  	if @room.save!
  		flash[:success] = "Create room successful!"
  	else 
  		flash[:error] = "Cannot create room"
  	end
  	redirect_to rooms_path
  end

  def show
    @room = Room.find(params[:id])
    redirect_to room_messages_path(@room)
  end
  def room_params
  	params.require(:room).permit(:name)
  end
end
