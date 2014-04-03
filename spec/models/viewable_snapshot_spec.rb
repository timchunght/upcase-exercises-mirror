require 'spec_helper'

describe ViewableSnapshot do
  it 'delegates attributes to its solution' do
    snapshot = build_stubbed(:snapshot)
    viewable_snapshot = ViewableSnapshot.new(snapshot)

    expect(viewable_snapshot.solution).to eq(snapshot.solution)
    expect(viewable_snapshot).to be_a(SimpleDelegator)
  end

  describe '#files' do
    it 'returns a collection of files' do
      snapshot = build_stubbed(:snapshot, diff: 'diff deploy.rb')
      StringIO.stub(:new).and_return('diff deploy.rb')
      viewable_snapshot = ViewableSnapshot.new(snapshot)

      expect(viewable_snapshot.files).to eq ['diff deploy.rb']
    end
  end
end
