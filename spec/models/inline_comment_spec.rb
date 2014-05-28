require 'spec_helper'

describe InlineComment do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:revision) }
  end

  describe '.chronological' do
    it 'returns comments in ascending order' do
      new_comment = create(:inline_comment, created_at: Date.today)
      old_comment = create(:inline_comment, created_at: 2.days.ago)

      expect(InlineComment.chronological).to eq [old_comment, new_comment]
    end
  end
end
