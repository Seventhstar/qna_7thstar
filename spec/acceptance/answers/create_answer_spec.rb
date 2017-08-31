require_relative '../acceptance_helper'

feature 'User answers a question', %q{
  In order to answer a question
  I want to be able to fill the answer form on a page of a question
} do

  given(:user)     { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated posts a valid answer' do
    sign_in(user)
    visit question_path(question)

    fill_in  'answer_body', with: 'My answer'
    click_on 'Create'

    within '.answers' do
      expect(page).to have_content 'My answer'
    end
  end

  scenario 'Non-authenticated user answers a question' do
    visit question_path(question)
    expect(page).not_to have_content 'Create Answer'
  end

  scenario 'Authenticated user tries to post an empty answer' do
    sign_in(user)
    visit question_path(question)

    click_on 'Create Answer'
    expect(page).to have_content "Body can't be blank"
 end

end
