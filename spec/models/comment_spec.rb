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

  describe '#solution_submitter' do
    it 'returns the user who created the solution the comment is attached to' do
      submitter = double('submitter')
      comment = build_stubbed(:comment)
      comment.solution.stub(:user).and_return(submitter)

      result = comment.solution_submitter

      expect(result).to eq(submitter)
    end
  end

  describe '#exercise' do
    it 'returns the exercise being commented on' do
      exercise = double('exercise')
      comment = build_stubbed(:comment)
      comment.solution.stub(:exercise).and_return(exercise)

      result = comment.exercise

      expect(result).to eq(exercise)
    end
  end
end
