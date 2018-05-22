require_relative '../../acceptance_helper'

feature 'Create comment for answer', %q{
  In order to add comment
  As an auth user
  I want to be able to add comment for answer
} do


  given! (:user) { create(:user) }
  given! (:question) { create(:question, user: user) }
  given! (:answer) { create(:answer, question: question, user: user) }

  let!(:owner_class) { 'answers' }

  it_behaves_like "Commentable"

end