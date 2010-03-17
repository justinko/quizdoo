class DashboardsController < ApplicationController
  before_filter :render_home_page
  
  def show
    @participating_quizzes = current_user.participating_quizzes_for_dashboard
    @your_quizzes = current_user.quizzes
    @questions_awaiting_approval = current_user.questions.awaiting_approval.all(
      :include => [:quiz, :suggester]
    )
  end
  
  private
  
  def render_home_page
    unless current_user
      render :template => 'pages/home' and return
    end
  end
end
