class SlackObserver
  SLACK_CHANNEL = "#upcase"

  pattr_initialize [:solution]

  def solution_submitted
    message = <<-EOS
      A new solution has been submitted by #{solution.user.username}!
      View it here: <#{submitted_solution_url}>"
    EOS
    message = message.squish
    Slack::Post.post(message, SLACK_CHANNEL)
  end

  private

  def submitted_solution_url
    Rails.application.routes.url_helpers.exercise_solution_url(
      solution.exercise,
      solution.user
    )
  end
end
