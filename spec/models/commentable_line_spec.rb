require 'spec_helper'

describe CommentableLine do
  include Rails.application.routes.url_helpers

  it 'decorates diff line' do
    diff_line = double('diff_line', foo: nil)
    commentable_line = CommentableLine.new(diff_line, double, double)

    commentable_line.foo

    expect(diff_line).to have_received(:foo)
  end

  describe '#comments' do
    it 'makes calls to the comment query object' do
      diff_line = double('diff_line', number: 1, file_name: 'foo')
      comment_locator = double('comment_locator', inline_comments_for: nil)
      line = CommentableLine.new(diff_line, comment_locator, double)

      line.comments

      expect(comment_locator).to have_received(:inline_comments_for).
        with(diff_line.file_name, diff_line.number)
    end
  end

  describe '#new_comment_path' do
    it 'returns the correct path' do
      solution = double('solution', to_param: 2)
      diff_line = double('diff_line', number: 1, file_name: 'foo')
      location = '3:foo:1'
      comment_locator = double('comment_locator')
      comment_locator.stub(:location_for).with('foo', 1).and_return(location)
      line = CommentableLine.new(diff_line, comment_locator, solution)

      expect(line.new_comment_path).
        to eq new_solution_comment_path(solution, location: '3:foo:1')
    end
  end
end
