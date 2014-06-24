require 'spec_helper'

feature 'User starts exercise', js: true do
  scenario 'with public key and receives clone URL and instructions' do
    exercise = create(:exercise, title: 'nullobject', instructions: 'Go go go')
    workflow = start_exercise_workflow(username: 'mruser', exercise: exercise)

    pause_background_jobs do
      workflow.start_exercise(public_keys: ['ssh-rsa 123'])
      expect(page).to have_content(I18n.t('clones.create.pending'))
    end

    expect(page).to have_content(%r{git clone git@.*:mruser/nullobject.git})
    expect(page).to display_exercise(exercise)
  end

  scenario 'without public key and uploads public key' do
    exercise = create(:exercise, title: 'nullobject', instructions: 'Go go go')
    workflow = start_exercise_workflow(username: 'mruser', exercise: exercise)

    workflow.start_exercise(public_keys: [])
    workflow.upload_public_key 'ssh-rsa 123'

    expect(page).to display_exercise(exercise)
  end

  scenario 'without username and sets username' do
    exercise = create(:exercise, title: 'nullobject', instructions: 'Go go go')
    workflow = start_exercise_workflow(username: '', exercise: exercise)

    workflow.start_exercise
    workflow.set_username 'mruser'

    expect(page).to display_exercise(exercise)
  end

  scenario 'without username and sets invalid username' do
    create(:user, username: 'existing')
    exercise = create(:exercise, title: 'nullobject', instructions: 'Go go go')
    workflow = start_exercise_workflow(username: '', exercise: exercise)

    workflow.start_exercise
    workflow.set_username 'existing'
    expect(page).to have_content('has already been taken')

    workflow.set_username 'mruser'
    expect(page).to display_exercise(exercise)
  end

  def display_exercise(exercise)
    have_content(exercise.instructions)
  end
end
