require 'spec_helper'

feature 'subscriber updates solution' do
  scenario 'sees new revision' do
    workflow = start_exercise_workflow
    workflow.submit_solution 'first_revision'

    workflow.update_solution 'second_revision'

    workflow.view_my_solution
    expect(page).to have_content('second_revision')
  end
end
