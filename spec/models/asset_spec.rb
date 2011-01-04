require 'spec_helper'

describe Asset do
  it { should belong_to(:site) }
  it { should validate_presence_of(:site_id) }
  it { should validate_presence_of(:file) }
end
