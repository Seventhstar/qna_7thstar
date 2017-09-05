class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  validates :body, presence: true

  default_scope { order(best: :desc, created_at: :asc) }

  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true


  def set_best
    Answer.transaction do
      self.question.answers.update_all(best: false)
      self.update!(best: true)
    end
  end

end
