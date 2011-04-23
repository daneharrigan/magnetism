require 'spec_helper'

describe Redirect do
  it { should belong_to(:site) }
  it { should belong_to(:page) }

  it { should validate_presence_of(:url) }
  it { should validate_presence_of(:page_id) }
  it { should validate_presence_of(:site_id) }
end
