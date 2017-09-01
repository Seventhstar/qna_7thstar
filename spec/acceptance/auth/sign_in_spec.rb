require 'rails_helper'

feature 'User sign in', %q{
  In order to be able ask question
  As an user
  I want to be able to sign in
} do

  given(:user) {create(:user)}

  scenario 'Registereg user try to sign in' do
    sign_in(user)
    #save_and_open_page
    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to sign in' do

    visit sign_in_path
    fill_in 'Email', with: 'wrong@test.info'
    fill_in 'Password', with: '123456'
    click_on 'Log in'
    expect(page).to have_content 'Invalid Email or password.'
    expect(current_path).to eq sign_in_path
  end


end