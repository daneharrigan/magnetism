require 'spec_helper'

describe Magnetism::PageNotFound do
  describe '#message' do
    it 'returns "The page you requested does not exist"' do
      page_not_found = Magnetism::PageNotFound.new
      page_not_found.message.should == 'The page you requested does not exist'
    end
  end
end
