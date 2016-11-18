class QuestionsChannel < ApplicationCable::Channel
  def follow
    stop_all_streams
    stream_from 'questions'
  end

  def unfollow
    stop_all_streams
  end
end
