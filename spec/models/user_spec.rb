require 'spec_helper'

describe User do
  describe '#valid?' do
    it { should_not validate_presence_of(:password) }
  end
end
