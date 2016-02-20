require 'test_helper'

feature 'Schedule' do
  scenario 'uploads input and displays output', :js => true do
    visit root_path

    input_file = Rails.root.join('test', 'fixtures', 'input', 'notamn3.in')
    # This is a workaround for Capybara refusing to handle overlapping elements
    page.execute_script("$('#input_file').appendTo('#upload_input');")
    page.attach_file('input_file', input_file)
    click_button 'Submit'
 
    assert_equal 2, page.all('#schedule tbody tr').count
  end
end
