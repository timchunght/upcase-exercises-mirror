module Github
  class Exercise
    pattr_initialize [
      :github_client,
      :github_repository,
      :local_exercise,
      :solution_factory,
    ]

    def import
      pull_requests = github_client.pull_requests(github_repository)
      pull_requests.each do |pull_request|
        solution_factory.new(pull_request: pull_request).import
      end
    end
  end
end
