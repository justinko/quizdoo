class QuizzesController < ApplicationController
  before_filter :require_user, :only => [:new, :edit, :update, :destroy]
  before_filter :find_quiz, :only => [:show, :edit, :update, :destroy]
  
  def index
    @recently_added = Quiz.recently_added
    @categories = Category.all(:order => 'name ASC')
  end
  
  def new
    @quiz = Quiz.new
  end
  
  def create
    @quiz = Quiz.new(params[:quiz])
    if @quiz.save
      redirect_to @quiz
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
  end
  
  def show
  end
end
