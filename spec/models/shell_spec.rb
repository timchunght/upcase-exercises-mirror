require 'spec_helper.rb'

describe Shell do
  describe '#execute' do
    it 'delegates executing the command to Cocaine' do
      line = double('command_line')

      expect(Cocaine::CommandLine).to receive(:new).and_return(line)
      expect(line).to receive(:run)

      Shell.new.execute('true')
    end
  end
end
