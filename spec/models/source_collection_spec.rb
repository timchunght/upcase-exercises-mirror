require 'spec_helper'

describe SourceCollection do
  it 'is enumerable' do
    source_collection = SourceCollection.new([])

    expect(source_collection).to be_a(Enumerable)
  end

  describe '#each' do
    it 'yields a source repository for each exercise' do
      exercises = [double('exercise'), double('exercise')]
      sources = exercises.map do |exercise|
        double('source').tap do |source|
          GIT_SERVER.stub(:source).with(exercise).and_return(source)
        end
      end
      result = []
      source_collection = SourceCollection.new(exercises)

      source_collection.each do |source|
        result << source
      end

      expect(result).to eq(sources)
    end
  end
end
