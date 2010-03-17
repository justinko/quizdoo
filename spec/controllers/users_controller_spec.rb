require 'spec_helper'

describe UsersController do
  integrate_views
  fixtures :users
  
  describe '#show' do
    it 'should find a user and render show template' do
      get :show, :username => users(:justin).username
      response.should be_success
      response.should render_template('show')
    end
    
    it 'should not find a user and render 404' do
      get :show, :username => 'blah'
      response.response_code.should eql(404)
      response.body.should eql('User not found.')
    end
  end
  
  describe '#new' do
    it {
      get :new
      response.should be_success
      response.should render_template('new')
    }
  end
  
  describe '#create' do
    it 'should create a user and redirect to root' do
      lambda {
        post :create, :user => { :name => 'Bob',
                                 :username => 'bob', 
                                 :email => 'bob@bob.com',
                                 :password => 'test',
                                 :password_confirmation => 'test' }
      }.should change(User, :count).by(1)
      
      response.should be_redirect
      response.should redirect_to(root_url)
    end
    
    it 'should not create a user and render the new action' do
      lambda {
        post :create, :user => {}
      }.should_not change(User, :count)

      response.should be_success
      response.should render_template('new')
    end
  end
  
  describe '#edit' do
    it 'should redirect if not logged in' do
      get :edit
      response.should be_redirect
    end
    
    describe 'User logged in' do
      before { login }
      
      it {
        get :edit
        response.should be_success
        response.should render_template('edit')
      }
    end
  end
  
  describe '#update' do
    it 'should redirect if not logged in' do
      put :update
      response.should redirect_to(login_url)
    end
    
    describe 'User logged in' do
      fixtures :users
      before { login }

      it 'should update user successfully' do
        put :update, :user => {:name => 'test name'}
        
        users(:justin).reload.name.should eql('test name')
        response.should be_redirect
        response.should redirect_to(account_url)
      end
      
      it 'should not update and render the edit action' do
        put :update, :user => {:name => ''}
        response.should be_success
        response.should render_template('edit')
      end
    end
  end
  
  describe '#destroy' do
    it 'should redirect if not logged in' do
      delete :destroy
      response.should redirect_to(login_url)
    end
    
    describe 'User logged in' do
      fixtures :users
      before { login }
      
      it 'should delete the user and redirect to root' do
        lambda { delete :destroy }.should change(User, :count).by(-1)
        response.should be_redirect
        response.should redirect_to(root_url)
      end
    end
  end
end
