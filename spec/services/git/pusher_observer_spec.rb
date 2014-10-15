require "spec_helper"

describe Git::PusherObserver do
  describe "#clone_created" do
    it "sends a trigger to pusher" do
      exercise = double("exercise")
      user = double("user")
      stub_channel(exercise: exercise, user: user) do |channel, channel_factory|
        observer = Git::PusherObserver.new(channel_factory)

        observer.clone_created(exercise, user, double("sha"))

        expect(channel).to have_received(:trigger).with("cloned")
      end
    end
  end

  describe "#diff_fetched" do
    it "sends a trigger to pusher" do
      exercise = double("exercise")
      user = double("user")
      clone = double("clone", exercise: exercise, user: user)
      stub_channel(exercise: exercise, user: user) do |channel, channel_factory|
        observer = Git::PusherObserver.new(channel_factory)

        observer.diff_fetched(clone, double("diff"))

        expect(channel).to have_received(:trigger).with("pushed")
      end
    end
  end

  def stub_channel(exercise:, user:)
    channel_factory = double("channel_factory")
    channel = double("channel")
    allow(channel_factory).
      to receive(:new).
      with(exercise: exercise, user: user).
      and_return(channel)
    allow(channel).to receive(:trigger)

    yield channel, channel_factory
  end
end
