require "spec_helper"

describe Feedback do
  describe "#revisions" do
    it "returns revisions" do
      revisions = double(:revisions)
      feedback = build_feedback(revisions: revisions)

      result = feedback.revisions

      expect(result).to eq(revisions)
    end
  end

  describe "#files" do
    it "delegates to its viewed revision" do
      files = double(:files)
      viewed_revision = double(:viewed_revision, files: files)
      feedback = build_feedback(viewed_revision: viewed_revision)

      result = feedback.files

      expect(result).to eq(files)
    end
  end

  describe "#viewed_revision" do
    it "returns the viewed revision" do
      viewed_revision = double(:viewed_revision)
      feedback = build_feedback(viewed_revision: viewed_revision)

      result = feedback.viewed_revision

      expect(result).to eq(viewed_revision)
    end
  end

  describe "#latest_revision?" do
    it "delegates to its viewed revision" do
      latest_revision = double("latest_revision")
      viewed_revision = double(:viewed_revision, latest?: latest_revision)
      feedback = build_feedback(viewed_revision: viewed_revision)

      result = feedback.latest_revision?

      expect(result).to eq(latest_revision)
    end
  end

  describe "#top_level_comments" do
    it "delegates to its comment locator" do
      top_level_comments = double("comment_locator.top_level_comments")
      comment_locator = double("comment_locator")
      comment_locator.stub(:top_level_comments).and_return(top_level_comments)
      feedback = build_feedback(comment_locator: comment_locator)

      result = feedback.top_level_comments

      expect(result).to eq(top_level_comments)
    end
  end

  def build_feedback(
    viewed_revision: double("viewed_revision"),
    revisions: double("revisions"),
    comment_locator: double("comment_locator")
  )
    Feedback.new(
      viewed_revision: viewed_revision,
      revisions: revisions,
      comment_locator: comment_locator
    )
  end
end
