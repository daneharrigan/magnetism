require 'spec_helper'

describe Comment do
  it { should belong_to(:page) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:message) }
end
