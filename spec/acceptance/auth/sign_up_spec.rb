require_relative '../acceptance_helper'
 
feature 'New User can sign up on the website', %q{
  In order to ask questions,
  I want to be able to sign up
} do

  scenario 'Non-registered user signs up' do
    visit sign_up_path
    fill_in 'Email', with: 'new_user2@test.info'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on('Sign me up', match: :smart)
    # page.find(:button, 'Sign up').click
    # save_and_open_page


    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end
end
