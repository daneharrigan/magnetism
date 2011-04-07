require 'spec_helper'

describe Comment do
  it { should belong_to(:page) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:message) }

  describe '#gravatar' do
    it 'returns the URL to the gravatar image'
  end
end
