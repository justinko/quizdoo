require 'spec_helper'

describe PasswordResetsController do
  integrate_views
  
  describe '#new' do
    it {
      get :new
      response.should be_success
      response.should render_template('new')
    }
  end

  describe '#create' do
    describe 'with user found' do
      it 'should send an email if email address is found' do
        user = users(:justin)
        mock.instance_of(User).deliver_password_reset_instructions!
        
        post :create, :email => user.email
        response.should be_redirect
        response.should redirect_to(login_url)
      end
      
      it 'should render new action if email address is not found' do
        dont_allow.instance_of(User).deliver_password_reset_instructions!
        
        post :create, :email => 'blah@blah.com'
        response.should be_success
        response.should render_template('new')
      end
    end
  end
  
  describe '#edit' do
    describe 'with perishable_token found' do
      it 'should render the edit action' do
        user = users(:justin)
        get :edit, :id => user.perishable_token
        response.should be_success
        response.should render_template('edit')
      end
    end
    
    describe 'with perishable_token not found' do
      it 'should redirect to root url' do
        get :edit, :id => 'blah'
        response.should be_redirect
        response.should redirect_to(root_url)
      end
    end
  end
  
  describe '#update' do
    describe 'with perishable_token found' do
      it 'should update password and redirect' do
        update_user
        response.should be_redirect
        flash[:success].should eql('Password updated')
        response.should redirect_to(root_url)
      end
      
      it 'should not update password and render edit action' do
        update_user :password => 'blah',
                    :password_confirmation => 'test'
                    
        response.should be_success
        response.should render_template('edit')
      end
      
      def update_user(params = {})
        user = users(:justin)
        put :update, :user => {}.update(params),
                     :id => user.perishable_token
      end
    end
    
    describe 'with perishable_token not found' do
      it 'should redirect to root url' do
        put :update, :user => {}, :id => 'blah'
        response.should be_redirect
        flash[:failure] = 'Password reset link is invalid'
        response.should redirect_to(root_url)
      end
    end
  end
end
