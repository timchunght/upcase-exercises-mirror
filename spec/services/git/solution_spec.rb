require 'spec_helper'

describe Git::Solution do
  it 'delegates attributes to its solution' do
    snapshot = build_stubbed(:snapshot)
    git_snapshot = Git::Solution.new(snapshot, double('parser_factory'))

    expect(git_snapshot.solution).to eq(snapshot.solution)
    expect(git_snapshot).to be_a(SimpleDelegator)
  end

  describe '#files' do
    it 'delegates to a diff parser' do
      diff = 'diff example.txt'
      files = double('files')
      parser = double('parser', parse: files)
      parser_factory = double('parser_factory')
      parser_factory.stub(:new).with(diff: diff).and_return(parser)
      snapshot = build_stubbed(:snapshot, diff: diff)
      git_snapshot = Git::Solution.new(snapshot, parser_factory)

      result = git_snapshot.files

      expect(result).to eq(files)
    end
  end
end
