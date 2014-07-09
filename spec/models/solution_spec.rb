require 'spec_helper'

describe Solution do
  it { should belong_to(:clone) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:revisions).dependent(:destroy) }
  it { should have_one(:exercise).through(:clone) }
  it { should have_one(:user).through(:clone) }

  it { should validate_presence_of(:clone) }

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
      revision = double('revisions.latest')
      solution = build_stubbed(:solution)
      solution.revisions.stub(:latest).and_return(revision)

      result = solution.latest_revision

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
