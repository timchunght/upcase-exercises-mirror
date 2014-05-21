require 'spec_helper'

describe Revision do
  it { should belong_to :solution }
  it { should have_many(:inline_comments).dependent(:destroy) }

  describe '#comments_for' do
    it 'returns the correct comments' do
      revision = create(:revision)
      comment1 = create_comment(revision, 'filename', 21)
      comment2 = create_comment(revision, 'filename', 21)
      other_line_comment = create_comment(revision, 'filename', 40)
      other_file_comment = create_comment(revision, 'other_file', 21)
      comments = [comment1, comment2]

      expect(revision.comments_for('filename', 21)).to match_array comments
    end

    def create_comment(revision, file_name, line_number)
      create(
        :inline_comment,
        revision: revision,
        file_name: file_name,
        line_number: line_number
      )
    end
  end
end
