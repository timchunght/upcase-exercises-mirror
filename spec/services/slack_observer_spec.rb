require "spec_helper"

describe SlackObserver do
  describe "#solution_submitted" do
    it "sends a notification to Slack" do
      user = double(:user, username: "awesome")
      exercise = double(:exercise)
      url_helper = double(:url_helper)
      allow(url_helper).to receive(:exercise_solution_url).
        with(exercise, user).and_return("sweet_url")
      message = I18n.t "slack.new_solution", name: "awesome", url: "sweet_url"

      slack = double(:slack, post: nil)

      observer = SlackObserver.new(
        exercise: exercise,
        user: user,
        url_helper: url_helper,
        slack: slack
      )
      observer.solution_submitted

      expect(slack).to have_received(:post).with(message)
    end
  end
end
