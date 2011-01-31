require 'spec_helper'

describe Blog do
  it { should belong_to(:page) }
end
