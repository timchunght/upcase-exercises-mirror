require 'spec_helper'

describe InlineComment do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:revision) }
  end
end
