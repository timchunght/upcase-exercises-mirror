require 'spec_helper'

feature 'subscriber updates solution', js: true do
  scenario 'sees new revision' do
    workflow = start_exercise_workflow
    workflow.submit_solution 'first_revision'
    expect(page).to have_content('first_revision')

    workflow.push_to_clone 'second_revision'
    workflow.view_my_solution
    expect(page).to have_content('second_revision')
  end
end
