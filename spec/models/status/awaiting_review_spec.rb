require 'spec_helper'

describe Status::AwaitingReview do
  describe '#applicable?' do
    context "if user has performed a review but are awaiting review" do
      it "returns true" do
        feedback_progress = double('feedback_progress')
        feedback_progress.
          stub(:user_has_reviewed_other_solution?).
          and_return(true)
        feedback_progress.stub(:user_is_awaiting_review?).and_return(true)

        result = build_status(feedback_progress).applicable?

        expect(result).to be_true
      end
    end

    context "if the user has not reviewed their other solution" do
      it "returns false" do
        feedback_progress = double('feedback_progress')
        feedback_progress.
          stub(:user_has_reviewed_other_solution?).
          and_return(false)
        feedback_progress.stub(:user_is_awaiting_review?).and_return(true)

        result = build_status(feedback_progress).applicable?

        expect(result).to be_false
      end
    end

    context "if the user has already received a review" do
      it "returns false" do
        feedback_progress = double('feedback_progress')
        feedback_progress.
          stub(:user_has_reviewed_other_solution?).
          and_return(true)
        feedback_progress.stub(:user_is_awaiting_review?).and_return(false)

        result = build_status(feedback_progress).applicable?

        expect(result).to be_false
      end
    end
  end

  describe '#to_partial_path' do
    it 'returns a string' do
      feedback_progress = double('feedback_progress')

      result = build_status(feedback_progress).to_partial_path

      expect(result).to eq('statuses/awaiting_review')
    end
  end

  def build_status(feedback_progress)
    Status::AwaitingReview.new(feedback_progress)
  end
end
