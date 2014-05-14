module Github
  class Solution
    pattr_initialize [
      :github_client,
      :local_exercise,
      :logger,
      :participation_factory,
      :pull_request,
    ]

    def import
      participation.import(diff)
    rescue StandardError => exception
      logger.error("Couldn't import solution to #{repository} by #{username}")
      logger.error("#{exception.class}: #{exception.message}")
    end

    private

    def participation
      participation_factory.new(user: user, exercise: local_exercise)
    end

    def user
      User.find(username)
    end

    def username
      pull_request.user.login
    end

    def diff
      github_client.pull_request(repository, number, headers)
    end

    def repository
      pull_request.base.repo.full_name
    end

    def number
      pull_request.number
    end

    def headers
      { accept: 'application/vnd.github.diff' }
    end
  end
end
