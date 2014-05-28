require 'spec_helper'

describe Revision do
  it { should belong_to :solution }
  it { should have_many(:inline_comments).dependent(:destroy) }
end
