require 'spec_helper'

describe Clone do
  it { should belong_to(:exercise) }
  it { should belong_to(:user) }
  it { should have_one(:solution).dependent(:destroy) }

  it 'enforces the Git SHA format' do
    should allow_value('abcdef1234567890abcdef1234567890abcdef12').
      for(:parent_sha).
        strict
    should_not allow_value('bad characters aaaaaaaaaaaaaaaaaaaaaaaaa').
      for(:parent_sha).
        strict
    should_not allow_value('a' * 39).
      for(:parent_sha).
        strict
    should_not allow_value('a' * 41).
      for(:parent_sha).
        strict
  end

  describe '#title' do
    it 'delegates to its exercise' do
      exercise = build_stubbed(:exercise)
      clone = build_stubbed(:clone, exercise: exercise)

      expect(clone.title).to eq(exercise.title)
    end
  end
end
