require 'spec_helper'

describe StringDatum do
  it { should have_many(:data) }
end
