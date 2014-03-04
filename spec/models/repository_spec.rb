require 'spec_helper'

describe Repository do
  describe '#exercise_path' do
    it 'returns a valid git repo url' do
      repository = Repository.new('repository-name')

      expect(repository.exercise_path).to eq('sources/repository-name')
    end
  end
end
