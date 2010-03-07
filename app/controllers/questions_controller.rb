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
    
    if current_user and not owner?
      @user_answer = current_user.answers.find_or_initialize_by_question_id(@question)
      @total_answered = current_user.total_answered(@quiz)
      @total_questions = @quiz.questions.count
    end
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
end
