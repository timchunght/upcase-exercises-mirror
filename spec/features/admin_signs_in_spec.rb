require 'spec_helper'

feature 'Learn admin signs in' do
  scenario 'and becomes Whetstone admin' do
    FakeLearn.sign_in 'admin' => true
    visit admin_root_url
    click_on 'Authorize'
    expect(page).to have_translation('admin.exercises.index.create_exercise')
  end
end
