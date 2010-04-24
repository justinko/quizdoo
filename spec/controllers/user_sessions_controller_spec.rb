require 'spec_helper'

describe UserSessionsController do
  integrate_views
  
  describe '#new' do
    it {
      get :new
      response.should be_success
      response.should render_template('new')
    }
  end
  
  describe '#create' do    
    before { @user = users(:justin) }
    
    it 'should create a new session successfully' do
      post :create, :user_session => { :username => @user.username,
                                       :password => 'password' }
      
      response.should be_redirect
      response.should redirect_to(root_url)
    end
    
    it 'should not create a session and render new action' do
      post :create, :user_session => {}
      
      response.should be_success
      response.should render_template('new')
    end
  end
end

describe UserSessionsController, 'User logged in' do
  before { login }
  
  it 'should destroy a session and redirect to login' do
    delete :destroy
    response.should be_redirect
    response.should redirect_to(login_url)
  end
end
