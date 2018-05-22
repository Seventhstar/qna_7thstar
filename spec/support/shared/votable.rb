shared_examples_for "Votable" do
  scenario 'Authenticated user (not author) votes', js: true do
    sign_in(user)
    visit_path

    within ".#{owner_class}" do
      click_on 'Up'
      expect(page).to have_content 'Rate: 1'
      expect(page).to have_content 'Reset'
      expect(page).to_not have_content 'Up'
      expect(page).to_not have_content 'Down'

      click_on 'Reset'
      expect(page).to_not have_content 'Reset'
      expect(page).to have_content 'Rate: 0'
      expect(page).to have_content 'Up'
      expect(page).to have_content 'Down'

      click_on 'Down'
      expect(page).to have_content 'Rate: -1'
      expect(page).to have_content 'Reset'
      expect(page).to_not have_content 'Up'
      expect(page).to_not have_content 'Down'
    end
  end

  scenario 'Author tries to vote' do
    sign_in(other_user)
    visit_path

    within ".#{owner_class}" do
      check_not_vote
    end
  end

  scenario 'Non-authenticated user tries to vote' do
    visit_path

    within ".#{owner_class}" do
      check_not_vote
    end
  end
end

def check_not_vote()
  expect(page).to have_content '0'
  expect(page).to_not have_content 'Up'
  expect(page).to_not have_content 'Reset'
  expect(page).to_not have_content 'Down'
end