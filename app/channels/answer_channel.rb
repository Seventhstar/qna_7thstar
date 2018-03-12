class AnswerChannel < ApplicationCable::Channel
  def subscribed
  end

  def follow(data)
    # p "data #{data} question_id = #{data['question_id']}"
    stream_from "answers_#{data['question_id']}"
  end

  def unsubscribed
    stop_all_streams # Any cleanup needed when channel is unsubscribed
  end
end
