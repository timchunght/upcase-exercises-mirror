if Rails.env.staging? || Rails.env.production?
  Slack::Post.configure(
    channel: ENV["SLACK_CHANNEL"],
    icon_emoji: ":ghost:",
    subdomain: "thoughtbot",
    token: ENV["SLACK_TOKEN"],
    username: "whetstone-bot"
  )

  SLACK_POST = Slack::Post
else
  require "fakes/slack_fake"

  SLACK_POST = SlackFake
end
