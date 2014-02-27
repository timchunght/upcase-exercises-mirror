require 'spec_helper'

feature 'Admin creates exercise' do
  scenario 'with valid data' do
    visit_new_exercise_form
    fill_in 'Title', with: 'Shakespeare Analyzer'
    fill_in 'Body', with: 'As a Shakespear buff, do this exercise'
    click_on I18n.t('helpers.submit.exercise.create')

    expect(page).to have_content('Shakespeare Analyzer')
  end

  scenario 'with invalid data' do
    visit_new_exercise_form
    click_on I18n.t('helpers.submit.exercise.create')

    expect(page).to have_content("can't be blank")
  end

  def visit_new_exercise_form
    sign_in_as_admin
    click_on I18n.t('admin.dashboards.show.exercises')
    click_on I18n.t('admin.exercises.index.create_exercise')
  end
end
