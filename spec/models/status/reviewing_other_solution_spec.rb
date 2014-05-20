require 'spec_helper'

describe Status::ReviewingOtherSolution do
  describe '#applicable?' do
    it "delegates to the review's viewing_other_solution? method" do
      expected = double('expected')
      review = double('review')
      review.stub(:viewing_other_solution?).and_return(expected)

      result = Status::ReviewingOtherSolution.new(review).applicable?

      expect(result).to eq(expected)
    end
  end

  describe '#to_partial_path' do
    it 'returns a string' do
      result = Status::ReviewingOtherSolution.new(double('review')).to_partial_path

      expect(result).to eq('statuses/reviewing_solution')
    end
  end
end
