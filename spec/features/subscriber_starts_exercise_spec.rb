require 'spec_helper'

feature 'User starts exercise' do
  scenario 'receives clone URL' do
    user = create(:user, username: 'mruser')
    exercise = create(:exercise, title: 'nullobject')

    visit exercise_path(exercise, as: user)
    click_on I18n.t('exercises.show.start_exercise')

    expect(page).to have_content(%r{git clone git@.*:mruser/nullobject.git})
  end
end
