require_relative '../../acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }

  let(:owner_class) {'question_attachments'}
  let(:fill_params) { { Title: 'My question', Body: 'My body'} }
  it_behaves_like "Attachable"

  def visit_path
    visit new_question_path
  end
end