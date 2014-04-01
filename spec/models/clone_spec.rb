require 'spec_helper'

describe Clone do
  it { should belong_to(:exercise) }
  it { should belong_to(:user) }
  it { should have_one(:solution).dependent(:destroy) }

  describe '#title' do
    it 'delegates to its exercise' do
      exercise = build_stubbed(:exercise)
      clone = build_stubbed(:clone, exercise: exercise)

      expect(clone.title).to eq(exercise.title)
    end
  end
end
