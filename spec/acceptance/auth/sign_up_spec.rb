require_relative '../../acceptance_helper'
require 'capybara/email/rspec'
 
feature 'New User can sign up on the website', %q{
  In order to ask questions,
  I want to be able to sign up
} do

  scenario 'Non-registered user signs up' do
    visit sign_up_path
    fill_in 'Email', with: 'new_user2@test.info'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    
    within '.actions' do
      page.find(:button, 'Sign up').click
    end

    open_email('new_user2@test.info')
    current_email.click_link 'Confirm my account'

    expect(page).to have_content 'Your email address has been successfully confirmed.'

  end
end
