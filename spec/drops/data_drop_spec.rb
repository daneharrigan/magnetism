require 'spec_helper'

describe DataDrop do
  before(:each) do
    @field = mock_model(Field, :input_name => 'foo', :value => 'Bar')
    page = mock_model(Page, :fields => [@field])

    @drop = DataDrop.new(page)
  end

  describe 'to_liquid' do
    it 'returns itself' do
      @drop.to_liquid.should == @drop
    end
  end

  describe 'invoke_drop' do
    context 'when the field exists' do
      it 'returns the field value' do
        @drop.invoke_drop(@field.input_name).should == @field.value
      end
    end

    context 'when the field does not exist' do
      it 'returns nil' do
        @drop.invoke_drop('cux').should be_nil
      end
    end
  end
end
