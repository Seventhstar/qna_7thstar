class Question < ApplicationRecord
  include Votable
  include Attachable
  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true

end
