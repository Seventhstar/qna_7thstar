require_relative '../../acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of answer
  I want to be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user tries to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'edit'
  end

  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'sees link to edit' do
      within '.answers' do
        expect(page).to have_link 'edit'
      end
    end

    scenario 'tries to edit his answer', js: true do
      click_on 'edit'
      within '.answers' do
        within '.edit_answer' do
          fill_in 'answer_body', with: 'updated answer'
        end
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'updated answer'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end

  scenario "Authenticated user tries to edit other user's answer" do
    other_user = create(:user)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end
end