require 'spec_helper'

describe Comment do
  it { should belong_to(:page) }
  it { should validate_presence_of(:author_name) }
  it { should validate_presence_of(:author_ip) }
  it { should validate_presence_of(:body) }

  describe '#gravatar' do
    it 'returns the URL to the gravatar image' do
      comment = Factory.build(:comment)

      hash_value = Digest::MD5.hexdigest(comment.author_email)
      url = "http://gravatar.com/avatar/#{hash_value}"

      comment.gravatar.should == url
    end
  end
end
