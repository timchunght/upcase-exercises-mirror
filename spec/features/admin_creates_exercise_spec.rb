require 'spec_helper'

feature 'Admin creates exercise' do
  scenario 'with valid data' do
    visit_new_exercise_form
    fill_in 'Title', with: 'Shakespeare Analyzer'
    fill_in 'exercise_body', with: 'As a Shakespeare buff, do this exercise'
    click_button I18n.t('helpers.submit.exercise.create')

    expect(page).to have_content('Shakespeare Analyzer')
  end

  scenario 'with invalid data' do
    visit_new_exercise_form
    click_button I18n.t('helpers.submit.exercise.create')

    expect(page).to have_content("can't be blank")
  end

  def visit_new_exercise_form
    sign_in_as_admin
    click_on I18n.t('admin.dashboards.show.exercises')
    click_link I18n.t('admin.exercises.index.create_exercise'), match: :first
  end
end
