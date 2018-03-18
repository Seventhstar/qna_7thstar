class QuestionChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    stream_from "questions"
  end

  def unsubscribed
    stop_all_streams
  end
end
