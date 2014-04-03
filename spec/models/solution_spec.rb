require 'spec_helper'

describe Solution do
  it { should belong_to(:clone) }
  it { should have_one(:snapshot) }

  it { should validate_presence_of(:clone) }

  describe '#user' do
    it 'delegates to its clone' do
      clone = build_stubbed(:clone)
      solution = build_stubbed(:solution, clone: clone)

      expect(solution.user).to eq(clone.user)
    end
  end

  describe '#exercise' do
    it 'delegates to its clone' do
      clone = build_stubbed(:clone)
      solution = build_stubbed(:solution, clone: clone)

      expect(solution.exercise).to eq(clone.exercise)
    end
  end

  describe '#to_param' do
    it 'returns the user ID' do
      solution = build_stubbed(:solution)

      expect(solution.to_param).to eq(solution.user.to_param)
    end
  end
end
