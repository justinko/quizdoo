class QuizzesController < ApplicationController
  before_filter :require_user, :except => [:index, :show]
  before_filter :find_quiz, :except => [:index, :new, :create]
  before_filter :authorize_quiz, :only => [:edit, :update]
  
  def index
    @recently_added = Quiz.recently_added
    @categories = Category.all(:order => 'name ASC')
  end
  
  def new
    @quiz = Quiz.new
  end
  
  def create
    @quiz = Quiz.new(params[:quiz])
    @quiz.user = current_user
    
    if @quiz.save
      redirect_to @quiz
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @quiz.update_attributes(params[:quiz])
      redirect_to @quiz
    else
      render :edit
    end
  end
  
  def show
  end
  
  def participate
    current_user.participate!(@quiz)
    flash[:success] = 'You are now participating in this quiz'
  rescue ActiveRecord::RecordInvalid => errors
    flash[:failure] = errors
  ensure
    redirect_to @quiz
  end
  
  def unparticipate
    current_user.unparticipate!(@quiz)
    flash[:success] = 'You are no longer participating in this quiz'
  rescue ActiveRecord::RecordNotFound
    flash[:failure] = 'You are not a participate of this quiz'
  ensure
    redirect_to @quiz
  end
end
