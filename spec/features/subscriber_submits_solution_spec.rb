require 'spec_helper'

feature 'subscriber submits solution' do
  scenario 'gets prompt to review another solution' do
    user = create(:user, username: 'myuser')
    exercise = create(:exercise, title: 'nullobject')
    create(:clone, user: user, exercise: exercise)

    other_user_solution = create_solution_for_user(exercise, 'otheruser')
    create(:snapshot, solution: other_user_solution)

    visit exercise_clone_path(exercise, as: user)
    click_on I18n.t('clones.show.submit_solution')

    expect(page).to have_css('.active', text: "otheruser's solution")
    expect(page).to have_content(I18n.t('solutions.solution.assigned'))
  end

  scenario 'a user can view their own solution' do
    stub_diff_command('diff deploy.rb') do
      user = create(:user, username: 'myuser')
      exercise = create(:exercise, title: 'null-object')
      create(:clone, user: user, exercise: exercise)

      other_user_solution = create_solution_for_user(exercise)
      create(:snapshot, diff: 'diff test.rb', solution: other_user_solution)

      visit exercise_clone_path(exercise, as: user)
      click_on I18n.t('clones.show.submit_solution')

      expect(page).to have_content('test.rb')

      click_on "#{user.username}'s solution"

      expect(page).to have_content('deploy.rb')
    end
  end

  def create_solution_for_user(exercise, username = 'a_user')
    other_user = create(:user, username: username)
    other_clone = create(:clone, user: other_user, exercise: exercise)
    create(:solution, clone: other_clone)
  end
end
