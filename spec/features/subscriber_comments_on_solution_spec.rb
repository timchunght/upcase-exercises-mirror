require 'spec_helper'

feature 'subscriber comments on solution' do
  scenario 'at the top level', js: true do
    exercise = create(:exercise)
    user = create(:user)
    create_completed_solution(user, exercise)
    other_user = create(:user)
    create_completed_solution(other_user, exercise)

    visit exercise_solution_path(exercise, other_user, as: user)
    within('.comment-form') do
      fill_in 'comment_text', with: 'Looks great!'
      click_on I18n.t('comments.form.submit')
    end

    expect(page).to have_content('Looks great!')
    expect_comment_input_to_be_empty
    expect_notification_to other_user.email, exercise.title
  end

  def create_completed_solution(user, exercise)
    clone = create(:clone, user: user, exercise: exercise)
    create(:solution, clone: clone).tap do |solution|
      create(:revision, solution: solution)
    end
  end

  def expect_comment_input_to_be_empty
    expect(page).to have_field('comment_text', with: '')
  end

  def expect_notification_to(email, exercise_title)
    message = open_last_email_for(email)
    expect(message).to have_subject(
      I18n.t('mailer.comment.subject', exercise: exercise_title)
    )
  end
end
