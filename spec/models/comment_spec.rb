require 'spec_helper'

describe Comment do
  it { should belong_to(:user) }
  it { should belong_to(:solution) }

  it { should validate_presence_of(:text) }
end
