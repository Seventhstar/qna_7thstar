class QuestionSerializer < ActiveModel::Serializer
  include CommentableSerializer
  include AttachableSerializer
  include VotableSerializer
  attributes :id, :title, :body, :created_at, :updated_at
  has_many :answers
end
