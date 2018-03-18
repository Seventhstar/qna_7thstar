class Comment < ApplicationRecord
  include Attachable
  belongs_to :user
  belongs_to :commentable, polymorphic: true, optional: true
  validates :body, presence: true

  def question_id
    self.commentable.respond_to?(:question_id) ? self.commentable.question_id : self.commentable.id
  end

end
