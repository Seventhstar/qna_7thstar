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

  context 'action cable: 2 sessions' do
    scenario "add comment to a question on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.question_comments' do
          click_on 'add comment'
          fill_in 'comment_body', with: 'Question comment'
          click_on 'Create Comment'

          expect(page).to have_content 'Question comment'
          expect(page).not_to have_content "Body can't be blank"
        end
      end

      Capybara.using_session('guest') do
        within '.question_comments' do
          expect(page).to have_content 'Question comment'
        end
      end
    end
  end


end