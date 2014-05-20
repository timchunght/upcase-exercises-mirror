require 'spec_helper'

describe Status::AwaitingReview do
  describe '#applicable?' do
    it 'returns true if user has reviewed their other solution and is awaiting review' do
      review = double('review')
      review.stub(:user_has_reviewed_other_solution?).and_return(true)
      review.stub(:user_is_awaiting_review?).and_return(true)

      result = build_status(review).applicable?

      expect(result).to be_true
    end

    it 'returns false if the user has not reviewed their other solution' do
      review = double('review')
      review.stub(:user_has_reviewed_other_solution?).and_return(false)
      review.stub(:user_is_awaiting_review?).and_return(true)

      result = build_status(review).applicable?

      expect(result).to be_false
    end

    it 'returns false if the user has already received a review' do
      review = double('review')
      review.stub(:user_has_reviewed_other_solution?).and_return(true)
      review.stub(:user_is_awaiting_review?).and_return(false)

      result = build_status(review).applicable?

      expect(result).to be_false
    end
  end

  describe '#to_partial_path' do
    it 'returns a string' do
      review = double('review')

      result = build_status(review).to_partial_path

      expect(result).to eq('statuses/awaiting_review')
    end
  end

  def build_status(review)
    Status::AwaitingReview.new(review)
  end
end
