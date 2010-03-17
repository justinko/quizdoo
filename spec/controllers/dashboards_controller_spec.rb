require 'spec_helper'

describe DashboardsController, 'User logged in' do
  integrate_views
  
  before { login }
  
  it 'should render the show action' do
    get :show
    response.should be_success
    response.should render_template('show')
  end
end

describe DashboardsController, 'User not logged in' do
  integrate_views
  
  it 'should render the home page' do
    get :show
    response.should be_success
    response.should render_template('pages/home')
  end
end
