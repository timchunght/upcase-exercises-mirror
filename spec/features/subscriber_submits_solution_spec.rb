require 'spec_helper'

feature 'subscriber submits solution' do
  scenario 'sees prompt to review another solution' do
    workflow = start_exercise_workflow
    workflow.create_solution_by_other_user(
      username: 'otheruser',
      filename: 'test.rb'
    )

    workflow.submit_solution

    expect(page).to have_content('test.rb')
    expect(page).to have_css('.active', text: "otheruser's solution")
    expect(page).to have_content(I18n.t('solutions.solution.assigned'))
    expect(page).not_to have_no_solutions_heading
  end

  scenario 'a user can view their own solution' do
    workflow = start_exercise_workflow
    workflow.create_solution_by_other_user
    workflow.submit_solution('example.rb')

    workflow.view_my_solution

    expect(page).to have_content('example.rb')
  end

  scenario 'sees their own solution until another user submits one' do
    workflow = start_exercise_workflow(username: 'myuser')

    workflow.submit_solution('mysolution.txt')

    expect(page).to have_css('.active', text: "myuser's solution")
    expect(page).to have_no_solutions_heading
  end

  def have_no_solutions_heading
    have_content(I18n.t('solutions.show.no_solutions_heading'))
  end
end
