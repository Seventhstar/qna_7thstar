require_relative '../../acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:owner_class) { 'answers' }
  
  let(:fill_params) {{Body: 'My answer'}}
  
  it_behaves_like "Attachable"

  def visit_path
    visit question_path(question)
  end
end