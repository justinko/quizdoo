require 'spec_helper'

describe QuizzesController do
  integrate_views
  fixtures :quizzes
  
  before { login }
  
  describe '#index' do
    it {
      get :index
      response.should be_success
      response.should render_template('index')
      assigns[:quizzes].should_not be_nil
    }
  end
  
  describe '#new' do
    it {
      get :new
      response.should be_success
      response.should render_template('new')
    }
  end
  
  describe '#create' do
    it 'should create a quiz successfully and redirect' do
      lambda {
        post :create, :quiz => {:title => 'blah'}
      }.should change(Quiz, :count).by(1)
      
      response.should be_redirect
      response.should redirect_to(quiz_url(assigns[:quiz]))
    end
    
    it 'should not create a quiz and render the new action' do
      lambda {
        post :create, :quiz => {:title => ''}
      }.should_not change(Quiz, :count)
      
      response.should be_success
      response.should render_template('new')
    end
  end
  
  describe '#edit' do
    it 'should authorize the quiz' do
      get :edit, :id => quizzes(:ruby).id
      response.should be_success
      response.should render_template('edit')
    end
    
    it 'should not authorize the quiz and redirect to root' do
      get :edit, :id => quizzes(:rails).id
      response.should be_redirect
      response.should redirect_to(root_url)
    end
  end
  
  describe '#update' do 
    before { @quiz = quizzes(:ruby) }
    
    it 'should update a quiz successfully' do
      put :update, :id => @quiz.id, :quiz => {:title => 'new title'}
      
      assigns[:quiz].title.should eql('new title')
      
      response.should be_redirect
      response.should redirect_to(quiz_url(assigns[:quiz]))
    end
    
    it 'should not update a quiz and render the edit action' do
      put :update, :id => @quiz.id, :quiz => {:title => ''}
      response.should be_success
      response.should render_template('edit')
    end
    
    it 'should not authorize the quiz and redirect to root' do
      put :update, :id => quizzes(:rails).id, :quiz => {:title => 'new title'}
      response.should be_redirect
      response.should redirect_to(root_url)
    end
  end
  
  describe '#show' do
    it 'should render successfully and touch last_viewed' do
      lambda {
        get :show, :id => quizzes(:rails).id
      }.should change { quizzes(:rails).reload.last_viewed }
      
      response.should be_success
      response.should render_template('show')
    end
    
    it 'should render successfully and not touch last_viewed' do
      lambda {
        get :show, :id => quizzes(:ruby).id
      }.should_not change { quizzes(:ruby).reload.last_viewed }
      
      response.should be_success
      response.should render_template('show')
    end
  end
  
  describe '#participate' do
    fixtures :participations
       
    it 'should not be succcessful if quiz owner is current_user' do
      lambda {
        post :participate, :id => quizzes(:ruby).id
      }.should_not change(Participation, :count)
      
      flash[:failure].should eql('You cannot participate in your own quiz')
      response.should be_redirect
      response.should redirect_to(quiz_url(assigns[:quiz]))
    end
    
    it 'should not be successful if current_user is already participating in the quiz' do
      lambda {
        post :participate, :id => quizzes(:rails).id
      }.should_not change(Participation, :count)

      flash[:failure].should eql('Quiz is already part of your participation list')
      response.should be_redirect
      response.should redirect_to(quiz_url(assigns[:quiz]))
    end
    
    it 'should create a new participation record and redirect to quiz' do
      participations(:rails).destroy
      quiz = quizzes(:rails)
      
      lambda {
        post :participate, :id => quiz.id
      }.should change(Participation, :count).by(1)
      
      flash[:success].should eql('You are now participating in this quiz')
      response.should be_redirect
      response.should redirect_to(quiz_url(quiz))
    end
  end
end

describe QuizzesController, 'User not logged in' do
  integrate_views
  fixtures :quizzes
  
  it 'should render the index action' do
    get :index
    response.should be_success
    response.should render_template('index')
  end
  
  it 'should render the show action' do
    get :show, :id => quizzes(:rails).id
    response.should be_success
    response.should render_template('show')
  end
end
