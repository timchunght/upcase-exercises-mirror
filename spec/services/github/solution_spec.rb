require 'spec_helper'

describe Github::Solution do
  describe '#import' do
    context 'with an existing user' do
      it 'imports the solution' do
        repository = 'thoughtbot/example'
        number = 21
        username = 'jferris'
        diff = '+++ xyz'
        github_client = double('github_client')
        github_client.
          stub(:pull_request).
          with(repository, number, accept: 'application/vnd.github.diff').
          and_return(diff)
        pull_request = build_pull_request_hash(repository, number, username)
        user = double('user')
        exercise = double('exercise')
        participation_factory = double('participation_factory')
        participation = stub_participation_from_factory(
          participation_factory,
          exercise,
          user
        )
        participation.stub(:import)
        User.stub(:find).with(username).and_return(user)
        github_solution = build_solution(
          local_exercise: exercise,
          github_client: github_client,
          participation_factory: participation_factory,
          pull_request: pull_request,
        )

        github_solution.import

        expect(participation).to have_received(:import).with(diff)
      end
    end

    context 'with an unknown user' do
      it 'skips the solution' do
        logger = double('logger')
        logger.stub(:error)
        pull_request = build_pull_request_hash('test/repo', 12, 'jferris')
        User.stub(:find).with('jferris').and_raise(StandardError.new('oops'))
        github_solution = build_solution(
          logger: logger,
          pull_request: pull_request,
        )

        github_solution.import

        expect(logger).to have_received(:error).
          with("Couldn't import solution to test/repo by jferris")
        expect(logger).to have_received(:error).
          with('StandardError: oops')
      end
    end
  end

  def build_solution(
    github_client: double('github_client'),
    local_exercise: double('exercise'),
    logger: double('logger'),
    participation_factory: double('participation_factory'),
    pull_request: nil
  )
    Github::Solution.new(
      github_client: github_client,
      local_exercise: local_exercise,
      logger: logger,
      participation_factory: participation_factory,
      pull_request: pull_request,
    )
  end

  def stub_participation_from_factory(factory, exercise, user)
    double('participation').tap do |participation|
      factory.
        stub(:new).
        with(user: user, exercise: exercise).
        and_return(participation)
    end
  end

  def build_pull_request_hash(repository, number, username)
    Hashie::Mash.new(
      'base' => { 'repo' => { 'full_name' => repository } },
      'number' => number,
      'user' => { 'login' => username },
    )
  end
end
