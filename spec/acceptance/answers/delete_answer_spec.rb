require_relative '../../acceptance_helper'

feature 'User deletes answer', %q{
In order to remove my answer
I want to be able to delete answers, of which I am the author
} do

  given!(:user) {create(:user)}
  given!(:question) {create(:question, user: user)}
  given!(:answer) {create(:answer, user: user, question: question)}

  scenario 'Authenticated user deletes his answer', js: true do
    sign_in(answer.user)
    visit question_path(question)

    answer_body = answer.body
    expect(page).to have_content answer_body

    click_on '[x]'
    page.driver.browser.switch_to.alert.accept  # подтверждаем удаление
    expect(page).not_to have_content answer.body
  end

  scenario "User can't delete other user's answer" do
    other_user = create(:user)
    sign_in(other_user)
    visit question_path(question)

    expect(page).not_to have_content '[x]'
  end

  scenario 'Non-authenticated user tries to delete an answer' do
    visit question_path(question)

    expect(page).not_to have_content '[x]'
  end
end
