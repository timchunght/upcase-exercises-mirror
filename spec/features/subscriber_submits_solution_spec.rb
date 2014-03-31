require 'spec_helper'

feature 'subscriber submits solution' do
  scenario 'gets prompt to review another solution' do
    user = create(:user, username: 'myuser')
    other_user = create(:user, username: 'otheruser')
    exercise = create(:exercise, title: 'nullobject')
    create(:clone, user: user, exercise: exercise)
    other_clone = create(:clone, user: other_user, exercise: exercise)
    create(:solution, clone: other_clone)

    visit exercise_clone_path(exercise, as: user)
    click_on I18n.t('clones.show.submit_solution')

    expect(page).to have_css('.active', text: "otheruser's solution")
    expect(page).to have_content(I18n.t('solutions.solution.assigned'))
  end
end
