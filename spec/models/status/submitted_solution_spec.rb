require 'spec_helper'

describe Status::SubmittedSolution do
  describe '#to_partial_path' do
    it 'returns a string' do
      result = Status::SubmittedSolution.new.to_partial_path

      expect(result).to eq('statuses/submitted_solution')
    end
  end

  describe '#applicable?' do
    it 'returns true' do
      result = Status::SubmittedSolution.new.applicable?

      expect(result).to be_true
    end
  end
end
