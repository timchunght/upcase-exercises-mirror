require 'spec_helper'

describe Status::SubmittedSolution do
  describe '#to_partial_path' do
    it 'returns a string' do
      review = double("review")
      result = Status::SubmittedSolution.new(review).to_partial_path

      expect(result).to eq('statuses/submitted_solution')
    end
  end

  describe "#applicable?" do
    context "when the user has a solution" do
      it "returns true" do
        review = double("review", user_has_solution?: true)
        result = Status::SubmittedSolution.new(review).applicable?

        expect(result).to be_true
      end
    end

    context "when the user has no solution" do
      it "returns false" do
        review = double("review", user_has_solution?: false)
        result = Status::SubmittedSolution.new(review).applicable?

        expect(result).to be_false
      end
    end
  end
end
