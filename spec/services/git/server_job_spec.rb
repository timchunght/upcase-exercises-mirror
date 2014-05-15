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

  describe '#error' do
    it 'sends notifications' do
      error = StandardError.new('oops')
      error_notifier = double('error_notifier')
      error_notifier.stub(:notify)
      dependencies = { error_notifier: error_notifier }
      Dependencies::RailsLoader.stub(:load).and_return(dependencies)
      job = Git::ServerJob.new(method_name: 'expected_method', data: [])

      job.error(job, error)

      expect(error_notifier).to have_received(:notify).with(error)
    end
  end
end
