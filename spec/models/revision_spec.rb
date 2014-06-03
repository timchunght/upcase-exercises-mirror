require 'spec_helper'

describe Revision do
  it { should belong_to :solution }
  it { should have_one(:exercise).through(:solution) }
  it { should have_one(:user).through(:solution) }
end
