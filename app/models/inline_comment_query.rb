class InlineCommentQuery
  add_method_tracer :comments_for

  def initialize(revision)
    @comments = revision.inline_comments.chronological
  end

  def comments_for(file_name, line_number)
    @comments.select do |comment|
      comment.file_name == file_name && comment.line_number == line_number
    end
  end
end
