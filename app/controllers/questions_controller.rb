class QuestionsController < ApplicationController
  before_filter :require_user, :except => :show
  before_filter :find_quiz
  before_filter :find_question, :except => [:new, :create]
  
  def new
    @question = Question.new
  end
  
  def create
    @question = @quiz.questions.build(params[:question])
    if @question.save
      redirect_to quiz_question_url(@quiz, @question)
    else
      render :new
    end
  end
    
  def show
    @answer = Answer.new
    @answers = @question.answers
  end
  
  def edit
  end
  
  def update
    if @question.update_attributes(params[:question])
      redirect_to quiz_question_url(@quiz, @question)
    else
      render :edit
    end
  end
  
  private
  
  def find_question
    @question = @quiz.questions.find(params[:id])
  end
end
