class SlackObserver
  pattr_initialize [
    :exercise,
    :user,
    :url_helper
  ]

  def solution_submitted
    Slack::Post.post(new_solution_message)
  end

  def clone_created
  end

  def revision_submitted
  end

  private

  def new_solution_message
    solution_url = url_helper.exercise_solution_url(exercise, user)
    I18n.t "slack.new_solution", name: user.username, url: solution_url
  end
end
