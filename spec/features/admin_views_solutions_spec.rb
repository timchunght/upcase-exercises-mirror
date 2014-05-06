require 'spec_helper'

feature 'admin views solutions to exercise' do
  scenario 'before submitting solution' do
    exercise = create(:exercise)
    other_user = create(:user, username: 'otheruser')
    clone = create(:clone, exercise: exercise, user: other_user)
    solution = create(:solution, clone: clone)
    create(:revision, solution: solution)

    visit_exercise exercise
    click_on 'View Solutions'

    expect(page).to have_content("otheruser's solution")
    expect(page).to have_content(I18n.t('solutions.show.no_solution'))
  end

  def visit_exercise(exercise)
    sign_in_as_admin
    click_on exercise.title
  end
end
