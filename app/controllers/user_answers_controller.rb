class UserAnswersController < ApplicationController
  before_filter :require_user
  before_filter :find_quiz, :except => :destroy
  before_filter :find_question, :except => :destroy
  
  def create
    current_user.answer_question!(@question, params)
    flash[:success] = 'Answer saved'
  rescue ActiveRecord::RecordNotFound
    flash[:failure] = 'Question or answer could not be found'
  ensure
    redirect_to quiz_question_url(@quiz, @question)
  end
  
  def destroy
    current_user.answers.find(params[:id]).destroy
  rescue ActiveRecord::RecordNotFound
    flash[:failure] = 'Could not reset this question'
  ensure
    redirect_to :back
  end
end
