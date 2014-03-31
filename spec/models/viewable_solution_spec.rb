require 'spec_helper'

describe ViewableSolution do
  it 'delegates attributes to its solution' do
    solution = build_stubbed(:solution)
    viewable_solution = build(:viewable_solution, solution: solution)

    expect(viewable_solution.user).to eq(solution.user)
    expect(viewable_solution).to be_a(SimpleDelegator)
  end

  describe '#active?' do
    it 'is an active solution' do
      viewable_solution = build(:viewable_solution, active: 'expected value')

      expect(viewable_solution.active?).to eq('expected value')
    end
  end

  describe '#assigned?' do
    it 'is an assigned solution' do
      viewable_solution = build(:viewable_solution, assigned: 'expected value')

      expect(viewable_solution.assigned?).to eq('expected value')
    end
  end
end
