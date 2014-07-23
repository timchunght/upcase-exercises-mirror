# Represents the portion of the review page which contains files and comments.
class Feedback
  pattr_initialize [:comment_locator!, :viewed_revision!, :revisions!]
  attr_reader :revisions, :viewed_revision

  delegate :files, to: :viewed_revision

  def latest_revision?
    viewed_revision.latest?
  end

  def top_level_comments
    comment_locator.top_level_comments
  end
end
