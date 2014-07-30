Slack::Post.configure(
  channel: ENV["SLACK_CHANNEL"],
  icon_emoji: ":ghost:",
  subdomain: "thoughtbot",
  token: ENV["SLACK_TOKEN"],
  username: "whetstone-bot"
)
