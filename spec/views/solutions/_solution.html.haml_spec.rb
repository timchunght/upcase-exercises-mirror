require 'spec_helper'

describe 'solutions/_solution.html.haml' do
  context 'with an active solution' do
    it 'has the active css class' do
      solution = stub_viewable_solution(active?: true)

      render solution

      expect(rendered).to have_css('.active')
    end
  end

  context 'with an inactive solution' do
    it 'does not have the active css class' do
      solution = stub_viewable_solution(active?: false)

      render solution

      expect(rendered).not_to have_css('.active')
    end
  end

  context 'with an assigned solution' do
    it 'has the assigned css class and text' do
      solution = stub_viewable_solution(assigned?: true)

      render solution

      expect(rendered).to have_css('.assigned')
      expect(rendered).to have_text(t('solutions.solution.assigned'))
    end
  end

  context 'with an unassigned solution' do
    it 'does not have the assigned css class and text' do
      solution = stub_viewable_solution(assigned?: false)

      render solution

      expect(rendered).not_to have_css('.assigned')
      expect(rendered).not_to have_text(t('solutions.solution.assigned'))
    end
  end

  it 'links to the solution' do
    solution = stub_viewable_solution
    url = exercise_solution_url(solution.exercise, solution.user)

    render solution

    expect(rendered).to have_css("a[href='#{url}']")
  end

  def stub_viewable_solution(stubs = {})
    defaults = { active?: false, assigned?: false }
    build_stubbed(:solution).tap do |solution|
      solution.stub(defaults.merge(stubs))
    end
  end
end
