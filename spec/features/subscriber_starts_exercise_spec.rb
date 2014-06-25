require 'spec_helper'

feature 'User starts exercise', js: true do
  scenario 'with public key and receives clone URL and instructions' do
    exercise = create(:exercise, title: 'nullobject')
    workflow = start_exercise_workflow(username: 'mruser', exercise: exercise)

    pause_background_jobs do
      workflow.start_exercise(public_keys: ['ssh-rsa 123'])
      expect(page).to have_content(I18n.t('clones.create.pending'))
    end

    expect(page).to have_content(%r{git clone git@.*:mruser/nullobject.git})
    expect(page).to display_exercise(exercise)
  end

  scenario 'without public key and uploads public key' do
    exercise = create(:exercise)
    workflow = start_exercise_workflow(exercise: exercise)

    workflow.start_exercise(public_keys: [])
    workflow.upload_public_key 'ssh-rsa 123'

    expect(page).to display_exercise(exercise)
  end

  scenario 'without public key and uploads invalid public key' do
    exercise = create(:exercise)
    workflow = start_exercise_workflow(exercise: exercise)
    workflow.start_exercise(public_keys: [])

    stub_invalid_fingerprint do
      workflow.upload_public_key
      expect(page).to have_content('did not contain a valid SSH public key')
    end

    stub_valid_fingerprint do
      workflow.upload_public_key
      expect(page).to display_exercise(exercise)
    end
  end

  scenario 'with public bad key and uploads new public key' do
    exercise = create(:exercise)
    workflow = start_exercise_workflow(exercise: exercise)

    workflow.start_exercise(public_keys: ['ssh-rsa invalid'])
    workflow.request_clone_help
    workflow.upload_public_key 'ssh-rsa 123'

    expect(page).to display_exercise(exercise)
  end

  scenario 'without username and sets username' do
    exercise = create(:exercise)
    workflow = start_exercise_workflow(username: '', exercise: exercise)

    workflow.start_exercise
    workflow.set_username 'mruser'

    expect(page).to display_exercise(exercise)
  end

  scenario 'without username and sets invalid username' do
    create(:user, username: 'existing')
    exercise = create(:exercise)
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

  def stub_invalid_fingerprint(&block)
    stub_fingerprint 'invalid', &block
  end

  def stub_valid_fingerprint(&block)
    fingerprint = %w(
      2048
      d4:58:a1:cb:14:94:77:cf:e9:f4:b1:ac:2e:48:05:d2
      user@example.com
      (RSA)
    ).join(' ')
    stub_fingerprint fingerprint, &block
  end

  def stub_fingerprint(fingerprint)
    Gitolite::FakeShell.with_stubs do |stubs|
      ShellStubber.new(stubs).fingerprint(fingerprint)
      yield
    end
  end
end
