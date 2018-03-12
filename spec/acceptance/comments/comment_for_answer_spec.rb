require_relative '../../acceptance_helper'

feature 'Create comment for answer', %q{
  In order to add comment
  As an auth user
  I want to be able to add comment for answer
} do


  given! (:user) { create(:user) }
  given! (:question) { create(:question, user: user) }
  given! (:answer) { create(:answer, question: question, user: user) }

  let(:answer_comment) { 'New question comment' }
  let(:first_answer) { '.li_answer_'+answer.id.to_s }

  scenario 'Auth user add comment for answer', js: true do
    sign_in(user)

    visit question_path(question)
    within '.answers' do
      within first_answer do
        click_on 'add comment'

        fill_in 'comment_body', with: answer_comment
        click_on 'Create Comment'
      end
    end
    
    expect(page).to have_content 'New question comment'

    within first_answer do
      within '.comment' do
        expect(page).to have_content '[x]'
      end
    end

  end

  scenario 'Auth user try to create invalid comment for answer', js:true do
    sign_in(user)

    visit question_path(question)
    within first_answer do
        click_on 'add comment'
        click_on 'Create Comment'
      end
      expect(page).to have_content "Body can't be blank"
  end
 
  scenario 'Non auth user add comment for answer', js:true do
    visit question_path(question)
    expect(page).not_to have_content 'add comment'
  end

  context "for action cable: 2 sessions" do
    given! (:answer2) { create(:answer, question: question, user: user) }

    scenario "answer appear in anower user index question page", js:true do
      Capybara.using_session('guest') do
        visit question_path(question)

        expect(page).to_not have_content answer_comment
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
        within first_answer do
          click_on 'add comment'
          fill_in 'comment_body', with: answer_comment
          click_on 'Create Comment'

          expect(page).to have_content answer_comment
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content answer_comment
          save_and_open_page
        end
      end

    end

  end

end