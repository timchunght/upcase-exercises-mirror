require "spec_helper"

describe SlackObserver do
  describe "#solution_submitted" do
    include Rails.application.routes.url_helpers

    it "sends a notification to Slack" do
      solution = build_stubbed(:solution)
      observer = SlackObserver.new(solution: solution)
      allow(Slack::Post).to receive(:post)

      observer.solution_submitted

      message = <<-EOS
        A new solution has been submitted by #{solution.user.username}!
        View it here: <#{exercise_solution_url(
          solution.exercise,
          solution.user
        )}>"
      EOS
      message = message.squish
      expect(Slack::Post).to have_received(:post).with(message, "#upcase")
    end
  end
end
