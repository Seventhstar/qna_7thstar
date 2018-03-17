class CommentChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "comments_#{data['question_id']}"
  end

  def unsubscribed
    stop_all_streams # Any cleanup needed when channel is unsubscribed
  end
end
