require 'spec_helper'

describe Git::ServerJob do
  describe '#perform' do
    it 'calls the correct method on the Git server' do
      git_server = double('git_server')
      git_server.stub(:expected_method)
      dependencies = { immediate_git_server: git_server }
      args = %w(one two)
      Dependencies::RailsLoader.stub(:load).and_return(dependencies)
      job = Git::ServerJob.new(method_name: 'expected_method', data: args)

      job.perform

      expect(git_server).to have_received(:expected_method).with(*args)
    end
  end
end
