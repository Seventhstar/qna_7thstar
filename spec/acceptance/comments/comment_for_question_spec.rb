require_relative '../../acceptance_helper'

feature 'Comment on question', %q{
  In order to discuss the question
  As an authenticated user
  I want to be able to leave comments
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }



  describe 'Auth user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'add comment', js: true do
      within '.question_comments' do
        click_on 'add comment'

        fill_in 'comment_body', with: 'New comment'
        click_on 'Create Comment'

        expect(page).to have_content 'New comment'
        expect(page).not_to have_content "Body can't be blank"
      end
    end

    scenario 'add empty comment', js: true do
      within '.question_comments' do
        click_on 'add comment'

        fill_in 'comment_body', with: ''
        click_on 'Create Comment'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  describe 'Non Auth user' do
    scenario 'add comment w/out auth' do
      visit question_path(question)

      within '.question_comments' do
        expect(page).not_to have_content 'add comment'
      end
    end
  end

end