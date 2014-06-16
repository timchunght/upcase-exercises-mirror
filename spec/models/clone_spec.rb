require 'spec_helper'

describe Clone do
  it { should belong_to(:exercise) }
  it { should belong_to(:user) }
  it { should have_many(:revisions).dependent(:destroy) }
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

  describe '#username' do
    it 'delegates to its user' do
      user = build_stubbed(:user, username: 'username')
      clone = build_stubbed(:clone, user: user)

      expect(clone.username).to eq('username')
    end
  end

  describe '#create_revision!' do
    it 'creates a new revision with the given attributes' do
      revision = double('revisions.create!')
      solution = build_stubbed(:solution)
      clone = build_stubbed(:clone, solution: solution)
      clone.
        revisions.
        stub(:create!).
        with(diff: 'example', solution: solution).
        and_return(revision)

      result = clone.create_revision!(diff: 'example')

      expect(result).to eq(revision)
    end
  end

  describe '#create_solution!' do
    it 'creates a solution with the latest revision' do
      revision = double('revisions.latest')
      solution = double('Solution.create!')
      clone = build_stubbed(:clone)
      clone.revisions.stub(:latest).and_return(revision)
      Solution.stub(:create!).with(clone: clone).and_return(solution)
      revision.stub(:update_attributes!)

      result = clone.create_solution!

      expect(result).to eq(solution)
      expect(revision).to have_received(:update_attributes!).
        with(solution: solution)
    end
  end
end
