require 'spec_helper'

feature 'Visitor signs in' do
  scenario 'using OAuth against existing Learn account' do
    visit root_url
    click_on 'Authorize'

    expect(page).to have_content('Learn Dashboard')
  end

  scenario 'while trying to view an exercise' do
    exercise = create(:exercise, title: 'Viewed Exercise')

    visit exercise_path(exercise)
    click_on 'Authorize'

    expect(page).to have_content('Viewed Exercise')
  end

  scenario 'using invalid OAuth token' do
    visit '/auth/failure'

    expect(page).to have_content('Authorize')
  end
end
