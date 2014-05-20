require 'spec_helper'

describe Status::AllStepsCompleted do
  describe '#applicable?' do
    it 'delegates to the review' do
      expected = double('expected')
      review = double('review')
      review.stub(:user_has_given_and_received_review?).and_return(expected)
      status = Status::AllStepsCompleted.new(review)

      result = status.applicable?

      expect(result).to eq(expected)
    end
  end

  describe '#to_partial_path' do
    it 'returns a string' do
      status = Status::AllStepsCompleted.new(double('review'))

      result = status.to_partial_path

      expect(result).to eq('statuses/all_steps_completed')
    end
  end
end
