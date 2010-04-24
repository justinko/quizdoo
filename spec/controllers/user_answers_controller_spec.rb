require 'spec_helper'

describe UserAnswersController do
  integrate_views
  fixtures :quizzes, :questions, :answers
  
  before { login }
  
  describe '#create' do
    before do
      @quiz = quizzes(:rails)
      @question = questions(:rails)
      @answer = answers(:rails_correct)
    end
    
    it 'should create a UserAnswer record for question' do
      UserAnswer.delete_all
      
      lambda {
        post :create, :quiz_id => @quiz.id,
                      :id => @question.id,
                      :user_answer => {:answer_id => @answer.id}
      }.should change(UserAnswer, :count).by(1)
      
      response.should be_redirect
      response.should redirect_to(quiz_question_url(@quiz, @question))
    end
    
    it 'should not create a UserAnswer record if one already exists for question' do     
      lambda {
        post :create, :quiz_id => @quiz.id,
                      :id => @question.id,
                      :user_answer => {:answer_id => @answer.id}
      }.should_not change(UserAnswer, :count)
      
      flash[:failure].should eql('User has already answered this question')
      response.should be_redirect
      response.should redirect_to(quiz_question_url(@quiz, @question))
    end
    
    it 'should not find an Answer record' do
      lambda {
        post :create, :quiz_id => @quiz.id,
                      :id => @question.id,
                      :user_answer => {:answer_id => 12345}
      }.should_not change(UserAnswer, :count)
      
      flash[:failure].should eql('Quiz, Question or Answer could not be found')
      response.should be_redirect
      response.should redirect_to(quiz_question_url(@quiz, @question))
    end
  end
  
  describe '#destroy' do
    fixtures :user_answers
    
    it 'should delete the record' do
      user_answer = user_answers(:rails)
      
      lambda {
        delete :destroy, :id => user_answer.id
      }.should change(UserAnswer, :count).by(-1)
      
      response.should be_redirect
      
      url = quiz_question_url user_answer.question.quiz,
                              user_answer.question
                              
      response.should redirect_to(url)
    end
    
    it 'should not find the record and redirect to root' do
      lambda {
        delete :destroy, :id => 12345
      }.should_not change(UserAnswer, :count)
      
      flash[:failure].should eql('Answer could not be found')
      response.should be_redirect
      response.should redirect_to(root_url)
    end
  end
end

describe UserAnswersController, 'User not logged in' do
  it 'should redirect to login for create action' do
    post :create
    response.should redirect_to(login_url)
  end
end
