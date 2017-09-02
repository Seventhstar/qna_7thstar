class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  validates :body, presence: true

  default_scope { order(best: :desc, created_at: :asc) }

  def set_best
    Answer.transaction do
      self.question.answers.update_all(best: false)
      self.update!(best: true)
    end
  end

end
