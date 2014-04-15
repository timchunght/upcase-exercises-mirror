require 'spec_helper'

describe Solution do
  it { should belong_to(:clone) }
  it { should have_one(:snapshot) }

  it { should validate_presence_of(:clone) }

  describe '#diff' do
    it 'delegates to its snapshot' do
      diff = 'diff example.txt'
      snapshot = build_stubbed(:snapshot, diff: diff)
      solution = build_stubbed(:solution, snapshot: snapshot)

      expect(solution.diff).to eq(diff)
    end
  end

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
end
