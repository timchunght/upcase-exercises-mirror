class CommentNotifier
  pattr_initialize :notification_factory

  def comment_created(comment)
    notification_factory.new(comment: comment).deliver
  end
end
