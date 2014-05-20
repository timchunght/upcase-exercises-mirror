require 'spec_helper'

describe Solution do
  it { should belong_to(:clone) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:revisions).dependent(:destroy) }
  it { should have_one(:exercise).through(:clone) }
  it { should have_one(:user).through(:clone) }

  it { should validate_presence_of(:clone) }

  describe '#diff' do
    it 'delegates to its latest revision' do
      diff = 'diff example.txt'
      solution = create(:solution)
      revise solution, diff: diff

      expect(solution.diff).to eq(diff)
    end
  end

  describe '#username' do
    it 'delegates to its clone' do
      clone = build_stubbed(:clone)
      clone.stub(:username).and_return('username')
      solution = build_stubbed(:solution, clone: clone)

      expect(solution.username).to eq(clone.username)
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

  describe '#has_comments?' do
    context 'when the solution has comments' do
      it 'returns true' do
        solution = create(:solution)
        create(:comment, solution: solution)

        expect(solution.has_comments?).to be_true
      end
    end

    context 'when the solution has no comments' do
      it 'returns false' do
        solution = build_stubbed(:solution)

        expect(solution.has_comments?).to be_false
      end
    end
  end

  def revise(solution, attributes)
    create :revision, attributes.merge(solution: solution)
  end
end
