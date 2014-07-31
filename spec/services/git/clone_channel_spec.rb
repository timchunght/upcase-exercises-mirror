require "spec_helper"

describe Git::CloneChannel do
  describe "#name" do
    it "generates a name based on the exercise and user" do
      exercise = double("exercise", id: "123")
      pusher = double("pusher")
      user = double("user", id: "456")
      clone_channel =
        Git::CloneChannel.new(exercise: exercise, pusher: pusher, user: user)

      result = clone_channel.name

      expect(result).to eq("clone.123.456")
    end
  end

  describe "#trigger" do
    it "pushes to a pusher channel with its name" do
      exercise = double("exercise", id: "123")
      pusher = double("pusher")
      user = double("user", id: "456")
      channel = double("channel")
      event = double("event")
      clone_channel =
        Git::CloneChannel.new(exercise: exercise, pusher: pusher, user: user)
      allow(pusher).to receive(:[]).with(clone_channel.name).and_return(channel)
      allow(channel).to receive(:trigger)

      clone_channel.trigger(event)

      expect(channel).to have_received(:trigger).with(event, "")
    end
  end
end
