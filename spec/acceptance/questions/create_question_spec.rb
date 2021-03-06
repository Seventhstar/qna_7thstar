require_relative '../../acceptance_helper'

feature 'Create question', %q{
  In order to get answers from a community
  as an authenticated user I want to be able to ask questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates a question' do
    sign_in(user)

    visit questions_path
    click_on 'New'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test body'
    click_on 'Create'

    expect(page).to have_content 'Test question'
    expect(page).to have_content 'Test body'
  end

  scenario 'Non-authenticated user tries to create a question' do
    visit questions_path
    click_on 'New'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Authenticated user tries to create a question without title and body' do
    sign_in(user)

    visit questions_path
    click_on 'New'
    click_on 'Create'

    expect(page).to have_content "Titlecan't be blank" #без пробела перед can`t т.к. bootstrap делает разные поля
    expect(page).to have_content "Bodycan't be blank"


  end
end
