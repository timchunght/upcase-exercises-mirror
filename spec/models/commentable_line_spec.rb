require 'spec_helper'

describe CommentableLine do
  it 'decorates diff line' do
    diff_line = double('diff_line', foo: nil)
    commentable_line = CommentableLine.new(diff_line, double, double)

    commentable_line.foo

    expect(diff_line).to have_received(:foo)
  end

  describe '#comments' do
    it 'makes calls to the comment query object' do
      diff_line = double('diff_line', number: 1, file_name: 'foo')
      comment_query = double('comment_query', comments_for: nil)
      line = CommentableLine.new(diff_line, comment_query, double)

      line.comments

      expect(comment_query).to have_received(:comments_for).
        with(diff_line.file_name, diff_line.number)
    end
  end

  describe '#new_comment_url' do
    it 'returns the correct path' do
      solution = double('solution', to_param: 1)
      diff_line = double('diff_line', number: 1, file_name: 'foo')
      line = CommentableLine.new(diff_line, double, solution)

      path = '/solutions/1/inline_comments/new?file_name=foo&line_number=1'
      expect(line.new_comment_path).to eq path

    end
  end
end
