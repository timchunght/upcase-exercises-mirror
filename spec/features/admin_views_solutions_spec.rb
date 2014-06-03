require 'spec_helper'

feature 'admin views solutions' do
  scenario 'before submitting solution' do
    exercise = create(:exercise)
    other_user = create(:user, username: 'otheruser')
    clone = create(:clone, exercise: exercise, user: other_user)
    solution = create(:solution, clone: clone)
    create(:revision, solution: solution)

    visit_exercise exercise
    click_on 'View Solutions'

    expect(page).to have_content(
      I18n.t('solutions.show.solution_for_user', username: 'otheruser')
    )
    expect(page).to have_content(I18n.t('solutions.show.no_solution'))
  end

  scenario 'sees list of all solutions' do
    solution1, solution2 = create_pair(:solution)
    visit_solutions
    expect_to_see_solution(solution1)
    expect_to_see_solution(solution2)
  end

  def visit_exercise(exercise)
    sign_in_as_admin
    click_on I18n.t('admin.dashboards.show.exercises')
    click_on exercise.title
  end

  def visit_solutions
    sign_in_as_admin
    click_on(I18n.t('admin.dashboards.show.solutions'))
  end

  def expect_to_see_solution(solution)
    expect(page).to have_content(solution.exercise.title)
    expect(page).to have_content(solution.user.username)
    expect(page).to have_content(solution.comments_count)
  end
end
