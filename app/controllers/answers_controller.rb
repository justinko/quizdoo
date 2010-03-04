class AnswersController < ApplicationController
  before_filter :require_user
  before_filter :find_quiz
  before_filter :find_question
  
  def create
    @answer = @question.answers.build(params[:answer])
    @answer.save
    redirect_to quiz_question_path(@quiz, @question)
  end
  
  private
  
  def find_question
    @question = @quiz.questions.find(params[:question_id])
  end
end
