require 'spec_helper'

feature 'User starts exercise' do
  scenario 'with public key and receives clone URL and instructions' do
    exercise = create(:exercise, title: 'nullobject', instructions: 'Go go go')
    workflow = start_exercise_workflow(username: 'mruser', exercise: exercise)

    workflow.start_exercise(public_keys: ['ssh-rsa 123'])

    expect(page).to have_content(%r{git clone git@.*:mruser/nullobject.git})
    expect(page).to have_content(exercise.instructions)
  end

  scenario 'without public key and uploads public key' do
    exercise = create(:exercise, title: 'nullobject', instructions: 'Go go go')
    workflow = start_exercise_workflow(username: 'mruser', exercise: exercise)

    workflow.start_exercise(public_keys: [])
    workflow.upload_public_key 'ssh-rsa 123'

    expect(page).to have_content(%r{git clone git@.*:mruser/nullobject.git})
    expect(page).to have_content(exercise.instructions)
  end
end
