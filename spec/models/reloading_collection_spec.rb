require 'spec_helper'

describe ReloadingCollection do
  it 'is enumerable' do
    relation = double('relation')
    live_collection = ReloadingCollection.new(relation)

    expect(live_collection).to be_a(Enumerable)
  end

  describe '#each' do
    it 'reloads the relation before yielding' do
      reloaded = %w(one two three)
      relation = double('relation', reload: reloaded)
      live_collection = ReloadingCollection.new(relation)
      result = []

      live_collection.each do |item|
        result << item
      end

      expect(result).to eq(reloaded)
    end
  end
end
