require_relative '../../acceptance_helper'
require 'capybara/email/rspec'


feature 'Authenticate with oauth', %q{
  In order to register and login
  As a user
  I want to be able to authenticate through social networks
} do

  given(:user) { create(:user) }

  describe 'Twitter' do
    scenario 'New user logs in with twitter' do
      clear_emails
      visit new_user_session_path

      mock_auth_hash(:twitter)
      click_on 'Sign in with Twitter'

      expect(page).to have_content('Add email information')

      fill_in 'auth_hash_info_email', with: 'twitter@test.ru'
      click_on 'Add'

      open_email('twitter@test.ru')

      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'

      visit new_user_session_path
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Successfully authenticated from twitter account.'
    end

    scenario 'can sign in from twitter account second time' do

      auth = mock_twitter_hash
      authorization = create(:authorization, user: user, provider: auth.provider, uid: auth.uid)

      visit root_path

      within '.navbar-right' do
        page.find(:link, 'Sign in').click
      end

      page.find(:link, 'Sign in with Twitter').click
      expect(page).to have_content 'Successfully authenticated from twitter account.'
    end

    scenario 'user not logs in if not confirm email' do
      clear_emails
      mock_twitter_hash
      visit new_user_session_path

      click_on 'Sign in with Twitter'
      fill_in 'auth_hash_info_email', with: 'twitter_1@test.com'
      click_on 'Add'

      expect(page).to have_content 'You have to confirm your email address before continuing.'
      
    end
  end

  describe 'Github' do
    scenario 'New user logs in with github' do
      clear_emails
      auth = mock_auth_hash(:github)

      visit new_user_session_path
      click_on 'Sign in with GitHub'

      expect(page).to have_content('You have to confirm your email address before continuing.')

      open_email(auth[:info][:email])

      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'

      visit new_user_session_path
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Successfully authenticated from github account.'
    end

    scenario 'Returning user logs in with github' do
      auth = mock_auth_hash(:github)
      user.update!(email: 'github@test.ru')
      authorization = create(:authorization, user: user, provider: auth.provider, uid: auth.uid)

      visit new_user_session_path
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Successfully authenticated from github account.'
    end
  end


end