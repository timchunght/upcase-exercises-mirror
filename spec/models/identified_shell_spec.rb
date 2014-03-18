require 'spec_helper'

describe IdentifiedShell do
  describe '#execute' do
    it 'executes the command with an identity file' do
      component = Shell.new
      identity = 'ssh-rsa abcdef'
      shell = IdentifiedShell.new(component, identity)

      result = shell.execute('cat "$IDENTITY_FILE"')

      expect(result.strip).to eq(identity)
    end
  end
end
