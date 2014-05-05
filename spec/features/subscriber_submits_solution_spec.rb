require 'spec_helper'

feature 'subscriber submits solution' do
  scenario 'gets prompt to review another solution' do
    exercise = create(:exercise)
    create_solution_for_user(exercise, 'otheruser', 'test.rb')

    submit_solution_to exercise

    expect(page).to have_content('test.rb')
    expect(page).to have_css('.active', text: "otheruser's solution")
    expect(page).to have_content(I18n.t('solutions.solution.assigned'))
    expect(page).not_to have_no_solutions_heading
  end

  scenario 'a user can view their own solution' do
    user = create(:user, username: 'myuser')
    exercise = create(:exercise)
    create_solution_for_user(exercise)

    stub_diff_command(diff('deploy.rb')) do
      submit_solution_to exercise, as: user
      click_on "myuser's solution"
    end

    expect(page).to have_content('deploy.rb')
  end

  scenario 'sees their own solution until another user submits one' do
    user = create(:user, username: 'myuser')
    exercise = create(:exercise)

    submit_solution_to exercise, as: user

    expect(page).to have_css('.active', text: "myuser's solution")
    expect(page).to have_no_solutions_heading
  end

  def submit_solution_to(exercise, options = {})
    user = options[:as] || create(:user)
    create(:clone, user: user, exercise: exercise)
    visit exercise_clone_path(exercise, as: user)
    click_on I18n.t('clones.show.submit_solution')
  end

  def create_solution_for_user(exercise, username = 'user', change = 'example')
    other_user = create(:user, username: username)
    other_clone = create(:clone, user: other_user, exercise: exercise)
    create(:solution, clone: other_clone).tap do |solution|
      create(:revision, diff: diff(change), solution: solution)
    end
  end

  def diff(filename)
    diff = <<-DIFF
      diff --git a/#{filename} b/#{filename}
      new file mode 100644
      index 0000000..8e1fbbd
      --- /dev/null
      +++ b/#{filename}
      +New file
    DIFF
    diff.strip_heredoc
  end

  def have_no_solutions_heading
    have_content(I18n.t('solutions.show.no_solutions_heading'))
  end
end
