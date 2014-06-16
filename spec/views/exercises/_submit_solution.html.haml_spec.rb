require 'spec_helper'

describe 'exercises/_submit_solution' do
  context 'before pushing' do
    it 'disables the button to submit' do
      exercise = build_stubbed(:exercise)
      overview = double('overview', exercise: exercise, unpushed?: true)

      render 'exercises/submit_solution', overview: overview

      expect(submit_button('no_commits', disabled: true)).to be_present
    end
  end

  context 'after pushing' do
    it 'enables the button to submit' do
      exercise = build_stubbed(:exercise)
      overview = double('overview', exercise: exercise, unpushed?: false)

      render 'exercises/submit_solution', overview: overview

      expect(submit_button('submit_solution', disabled: false)).to be_present
    end
  end

  def submit_button(caption, options)
    page.find_button(I18n.t("exercises.show.#{caption}"), options)
  end

  def page
    Capybara.string(rendered)
  end
end
