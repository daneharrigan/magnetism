require 'spec_helper'

describe Datum do
  it { should belong_to(:field) }
  it { should belong_to(:entry) }
  it { should belong_to(:page) }
end
