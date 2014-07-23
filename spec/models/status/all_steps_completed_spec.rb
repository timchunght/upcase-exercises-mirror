require 'spec_helper'

describe Status::AllStepsCompleted do
  describe '#applicable?' do
    it 'delegates to the feedback progress' do
      expected = double('expected')
      feedback_progress = double('feedback_progress')
      feedback_progress.
        stub(:user_has_given_and_received_review?).
        and_return(expected)
      status = Status::AllStepsCompleted.new(feedback_progress)

      result = status.applicable?

      expect(result).to eq(expected)
    end
  end

  describe '#to_partial_path' do
    it 'returns a string' do
      status = Status::AllStepsCompleted.new(double('feedback_progress'))

      result = status.to_partial_path

      expect(result).to eq('statuses/all_steps_completed')
    end
  end
end
