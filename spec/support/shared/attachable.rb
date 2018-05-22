shared_examples_for "Attachable" do
  background do
    sign_in user
    visit_path
  end

  scenario 'User adds file to answer', js: true do
    
    fill_params.each do |key, value|
      puts "key: #{key}"
      fill_in key, with: value
    end

    click_on 'add file'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'add file'
    all('input[type="file"]').last.set("#{Rails.root}/spec/rails_helper.rb")
    click_on 'Create'

    within ".#{owner_class}" do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end
end