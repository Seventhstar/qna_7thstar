class CommentChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
  end

  def follow(data)
    # p "data #{data} question_id = #{data['question_id']}"
    stream_from "comments_#{data['question_id']}"
  end

  def unsubscribed
    stop_all_streams # Any cleanup needed when channel is unsubscribed
  end
end
