require 'spec_helper'

feature 'Visitor signs in' do
  scenario 'using OAuth against existing Learn account' do
    visit root_url
    click_on 'Authorize'
    expect(page).to have_content('Welcome')
  end
end
