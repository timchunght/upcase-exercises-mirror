require 'spec_helper'

describe Solution do
  it { should belong_to(:clone) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:revisions).dependent(:destroy) }

  it { should validate_presence_of(:clone) }

  describe '#diff' do
    it 'delegates to its latest revision' do
      diff = 'diff example.txt'
      solution = create(:solution)
      revise solution, diff: diff

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

  describe '#latest_revision' do
    it 'returns the most recently created revision for this solution' do
      solution = create(:solution)
      other_solution = create(:solution)
      revise solution, created_at: 2.day.ago, diff: 'middle'
      revise solution, created_at: 1.day.ago, diff: 'latest'
      revise solution, created_at: 3.day.ago, diff: 'oldest'
      revise other_solution, created_at: Time.now, diff: 'other'

      result = solution.latest_revision

      expect(result.diff).to eq('latest')
    end
  end

  describe '#create_revision!' do
    it 'creates a new revision with the given attributes' do
      revision = double('revision')
      solution = build_stubbed(:solution)
      solution.
        revisions.
        stub(:create!).
        with(diff: 'example').
        and_return(revision)

      result = solution.create_revision!(diff: 'example')

      expect(result).to eq(revision)
    end
  end

  def revise(solution, attributes)
    create :revision, attributes.merge(solution: solution)
  end
end
