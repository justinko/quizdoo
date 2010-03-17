require 'spec_helper'

describe PagesController do
  integrate_views
  
  describe '#home' do
    it {
      get :show, :id => 'home'
      response.should be_success
      response.should render_template('home')
    }
  end
end
