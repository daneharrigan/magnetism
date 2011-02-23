require 'spec_helper'

describe Blog do
  it { should belong_to(:page) }
  it { should have_many(:comments) }
end
