require 'spec_helper'

describe Admin::TemplatesController do
  before(:each) { login_as Factory(:user) }

  describe '#edit' do
    describe '#association_group' do
      it 'returns an array of the theme, template and field' do
        field = Factory(:field)
        association_group = [field.template.theme, field.template, field]
        params = {
          :theme_id => field.template.theme.id,
          :id => field.template.id
        }

        get :edit, params
        controller.association_group(field).should == association_group
      end
    end
  end
end
