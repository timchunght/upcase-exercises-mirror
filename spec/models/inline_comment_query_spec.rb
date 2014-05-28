require 'spec_helper'

describe InlineCommentQuery do
  describe '#comments_for' do
    it 'filters comments by file name and line number' do
      comment1 = double('comment1', file_name: 'right_file', line_number: 1)
      comment2 = double('comment2', file_name: 'right_file', line_number: 1)
      wrong_file = double('wrong_file', file_name: 'wrong_file', line_number: 1)
      wrong_line = double('wrong_line', file_name: 'right_file', line_number: 2)

      comments = [comment1, comment2, wrong_file, wrong_line]
      comments.stub(:chronological).and_return(comments)

      revision = double('revision', inline_comments: comments)
      query = InlineCommentQuery.new(revision)

      expect(comments).to have_received(:chronological)
      expect(query.comments_for('right_file', 1)).to eq [comment1, comment2]
    end
  end
end
