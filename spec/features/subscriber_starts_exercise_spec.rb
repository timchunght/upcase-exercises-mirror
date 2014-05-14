require 'spec_helper'

feature 'User starts exercise' do
  scenario 'receives clone URL and instructions' do
    user = create(:user, username: 'mruser')
    exercise = create(:exercise, title: 'nullobject', instructions: 'Go go go')

    start_exercise_as_user(exercise, user)

    expect(page).to have_content(%r{git clone git@.*:mruser/nullobject.git})
    expect(page).to have_content(exercise.instructions)
  end

  def start_exercise_as_user(exercise, user)
    visit exercise_path(exercise, as: user)
    click_on I18n.t('exercises.show.start_exercise')
  end
end
