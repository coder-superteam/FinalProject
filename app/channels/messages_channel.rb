class MessagesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "messages"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def test(data)
    ActionCable.server.broadcast('messages', message: "Test: #{data} hahaha")
  end
end
