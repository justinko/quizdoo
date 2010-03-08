require 'spec_helper'

describe AnswersController, 'User logged in' do
  integrate_views
  fixtures :users, :quizzes, :questions, :answers
  
  before do
    login(users(:justin))
    @answer = answers(:one)
  end
  
  it 'should create an answer record' do
    lambda {
      post :create, answer_params
    }.should change(Answer, :count).by(1)
  end
  
  it 'should redirect to question' do
    post :create, answer_params
    response.should be_redirect
    path = quiz_question_path(quizzes(:rails), questions(:one))
    response.should redirect_to(path)
  end
  
  it 'should render the edit partial' do
    get :edit, :id => @answer.id, :format => 'js'
    response.should respond_with(:success, :content_type => :js)
  end
  
  it 'should update successfully' do
    put :update, :id => @answer.id, :format => 'js', :answer => {}
    response.should respond_with(:success, :content_type => :js)
  end
  
  it 'should not update and render text' do
    put :update, :id => @answer.id, :format => 'js', :answer => {:body => ''}
    response.should respond_with(:unprocessable_entity, :content_type => :js)
  end
  
  it 'should render the show action' do
    get :show, :id => @answer.id, :format => 'js'
    response.should respond_with(:success, :content_type => :js)
  end
    
  it 'should destroy an answer' do
    delete :destroy, :id => @answer.id, :format => 'js'
    response.should respond_with(:success, :content_type => :js)
  end
  
  def answer_params
    { :id => quizzes(:rails),
      :question_id => questions(:one),
      :answer => {:body => 'blah'}
    }
  end
end
