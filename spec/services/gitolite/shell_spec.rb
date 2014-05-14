require 'spec_helper.rb'

describe Gitolite::Shell do
  describe '#execute' do
    it 'delegates executing the command to Cocaine' do
      line = double('command_line')

      expect(Cocaine::CommandLine).to receive(:new).and_return(line)
      expect(line).to receive(:run)

      Gitolite::Shell.new.execute('true')
    end
  end
end
