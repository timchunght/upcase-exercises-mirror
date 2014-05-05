require 'spec_helper'

describe Solution do
  it { should belong_to(:clone) }
  it { should have_one(:revision).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of(:clone) }

  describe '#diff' do
    it 'delegates to its revision' do
      diff = 'diff example.txt'
      revision = build_stubbed(:revision, diff: diff)
      solution = build_stubbed(:solution, revision: revision)

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
