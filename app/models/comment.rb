class Comment < ApplicationRecord
  include Attachable
  belongs_to :user
  belongs_to :commentable, polymorphic: true, optional: true
  validates :body, presence: true
end
