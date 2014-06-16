require 'spec_helper'

describe Revision do
  it { should belong_to :clone }
  it { should belong_to :solution }
  it { should have_one(:exercise).through(:solution) }
  it { should have_one(:user).through(:solution) }
  it { should validate_presence_of(:diff) }

  describe '#latest' do
    it 'returns the most recently created revision' do
      create :revision, created_at: 2.day.ago, diff: 'middle'
      create :revision, created_at: 1.day.ago, diff: 'latest'
      create :revision, created_at: 3.day.ago, diff: 'oldest'

      result = Revision.latest

      expect(result.diff).to eq('latest')
    end
  end
end
