require 'spec_helper'

describe Comment do
  it { should belong_to(:user) }
  it { should belong_to(:solution) }

  it { should validate_presence_of(:text) }

  describe '#solution' do
    it 'caches the number of comments' do
      solution = create(:solution)
      2.times { create(:comment, solution: solution) }

      expect(solution.reload.comments_count).to eq(2)
    end
  end
end
