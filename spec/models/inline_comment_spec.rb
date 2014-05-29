require 'spec_helper'

describe InlineComment do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:revision) }
  end

  describe '.chronological' do
    it 'returns comments in ascending order' do
      new_comment = create(:inline_comment, created_at: Date.today)
      old_comment = create(:inline_comment, created_at: 2.days.ago)

      expect(InlineComment.chronological).to eq [old_comment, new_comment]
    end
  end

  describe '#user' do
    it "returns its revision's user" do
      submitter = double('submitter')
      comment = build_stubbed(:inline_comment)
      comment.revision.stub(:user).and_return(submitter)

      result = comment.solution_submitter

      expect(result).to eq(submitter)
    end
  end

  describe '#exercise' do
    it 'returns the exercise being commented on' do
      exercise = double('exercise')
      comment = build_stubbed(:inline_comment)
      comment.revision.stub(:exercise).and_return(exercise)

      result = comment.exercise

      expect(result).to eq(exercise)
    end
  end
end
