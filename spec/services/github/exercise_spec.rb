require 'spec_helper'

describe Github::Exercise do
  describe '#import' do
    it 'imports each solution to the exercise' do
      repository = 'thoughtbot/example-exercise'
      pull_requests = [double('pull_request_one'), double('pull_request_two')]
      exercise = double('exercise')
      solution_factory = double('solution_factory')
      solutions = stub_solutions_from_factory(solution_factory, pull_requests)
      github_client = stub_client_with_pull_requests(repository, pull_requests)
      github_exercise = Github::Exercise.new(
        github_client: github_client,
        github_repository: repository,
        local_exercise: exercise,
        solution_factory: solution_factory,
      )

      github_exercise.import

      solutions.each do |solution|
        expect(solution).to have_received(:import)
      end
    end
  end

  def stub_client_with_pull_requests(repository, pull_requests)
    double('client').tap do |client|
      client.stub(:pull_requests).with(repository).and_return(pull_requests)
    end
  end

  def stub_solutions_from_factory(factory, pull_requests)
    pull_requests.map do |pull_request|
      double('solution').tap do |solution|
        solution.stub(:import)
        factory.stub(:new).with(pull_request: pull_request).and_return(solution)
      end
    end
  end
end
