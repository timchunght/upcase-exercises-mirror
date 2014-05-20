require 'spec_helper'

feature 'subscriber submits solution' do
  scenario 'sees prompt to review another solution' do
    workflow = start_exercise_workflow
    workflow.create_solution_by_other_user(
      username: 'otheruser'
    )

    workflow.submit_solution('mysolution.txt')

    expect(page).to have_content('mysolution.txt')
    expect(page).to have_css(
      '.active',
      text: I18n.t('solutions.show.my_solution'),
    )
    expect(page).not_to have_no_solutions_heading
  end

  scenario 'views another solution' do
    workflow = start_exercise_workflow
    workflow.create_solution_by_other_user(
      username: 'otheruser',
      filename: 'other_user.txt',
    )
    workflow.submit_solution

    workflow.view_solution_by('otheruser')

    expect(page).to have_content('other_user.txt')
  end

  scenario 'sees their own solution until another user submits one' do
    workflow = start_exercise_workflow(username: 'myuser')

    workflow.submit_solution('mysolution.txt')

    expect(page).to have_css(
      '.active',
      text: I18n.t('solutions.show.my_solution'),
    )
    expect(page).to have_no_solutions_heading
  end

  def have_no_solutions_heading
    have_content(I18n.t('solutions.show.no_solutions_heading'))
  end
end
