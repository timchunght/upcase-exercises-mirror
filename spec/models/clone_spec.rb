require 'spec_helper'

describe Clone do
  it { should belong_to(:exercise) }
  it { should belong_to(:user) }
  it { should have_one(:solution).dependent(:destroy) }

  describe '#repository' do
    it 'returns the repository for itself' do
      user = build_stubbed(:user)
      exercise = build_stubbed(:exercise, slug: 'repository')
      repository = double('repository')
      GIT_SERVER.stub(:clone).with(exercise, user).and_return(repository)
      clone = Clone.new(user: user, exercise: exercise)

      result = clone.repository

      expect(result).to eq(repository)
    end
  end

  describe '#title' do
    it 'delegates to its exercise' do
      exercise = build_stubbed(:exercise)
      clone = build_stubbed(:clone, exercise: exercise)

      expect(clone.title).to eq(exercise.title)
    end
  end
end
