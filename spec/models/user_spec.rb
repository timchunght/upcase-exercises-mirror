require 'spec_helper'

describe User do
  it { should have_many(:public_keys).dependent(:destroy) }

  describe '#valid?' do
    it { should_not validate_presence_of(:password) }
  end
end
