require "spec_helper"

describe Overview do
  describe "#exercise" do
    it "returns its exercise" do
      exercise = double("exercise")
      overview = build_overview(exercise: exercise)

      expect(overview.exercise).to eq(exercise)
    end
  end

  describe "#title" do
    it "delegates to its exercise" do
      exercise = double("exercise", title: "expected")
      overview = build_overview(exercise: exercise)

      expect(overview.title).to eq("expected")
    end
  end

  describe "#channel_name" do
    it "delegates to its channel" do
      channel_name = double("channel_name")
      channel = double("channel", name: channel_name)
      overview = build_overview(channel: channel)

      result = overview.channel_name

      expect(result).to eq(channel_name)
    end
  end

  describe "#clone" do
    it "delegates to its participation" do
      clone = double("clone")
      participation = double("participation", find_clone: clone)
      overview = build_overview(participation: participation)

      result = overview.clone

      expect(result).to eq(clone)
    end
  end

  describe "#files" do
    it "delegates to its revision" do
      files = double("revision.files")
      revision = double("revision", files: files)
      overview = build_overview(revision: revision)

      result = overview.files

      expect(result).to eq(files)
    end
  end

  describe "#has_clone?" do
    it "delegates to its participation" do
      participation_result = double("participation.has_clone?")
      participation = double("participation", has_clone?: participation_result)
      overview = build_overview(participation: participation)

      result = overview.has_clone?

      expect(result).to eq(participation_result)
    end
  end

  describe "#has_public_key?" do
    context "for a user with a public key" do
      it "returns true" do
        user = build_stubbed(:user)
        user.stub(:public_keys).and_return([double("public_key")])
        overview = build_overview(user: user)

        expect(overview).to have_public_key
      end
    end

    context "for a user with no public keys" do
      it "returns false" do
        user = build_stubbed(:user)
        user.stub(:public_keys).and_return([])
        overview = build_overview(user: user)

        expect(overview).not_to have_public_key
      end
    end
  end

  describe "#unpushed?" do
    it "delegates to its participation" do
      participation_result = double("participation.unpushed?")
      participation = double("participation", unpushed?: participation_result)
      overview = build_overview(participation: participation)

      result = overview.unpushed?

      expect(result).to eq(participation_result)
    end
  end

  describe "#username?" do
    it "delegates to its user" do
      user_result = double("user.username?")
      user = double("user", username?: user_result)
      overview = build_overview(user: user)

      result = overview.username?

      expect(result).to eq(user_result)
    end
  end

  def build_overview(
    channel: double("channel"),
    exercise: double("exercise"),
    participation: double("participation"),
    revision: double("revision"),
    user: double("user")
  )
    Overview.new(
      channel: channel,
      exercise: exercise,
      participation: participation,
      revision: revision,
      user: user,
    )
  end
end
