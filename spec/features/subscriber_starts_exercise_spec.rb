require 'spec_helper'

feature 'User starts exercise' do
  scenario 'receives clone URL' do
    user = create(:user, username: 'mruser')
    exercise = create(:exercise, title: 'nullobject')

    visit exercise_path(exercise, as: user)
    click_on 'Start Exercise'

    expect(page).to have_content(%r{git clone git@.*:mruser/nullobject.git})
  end
end
