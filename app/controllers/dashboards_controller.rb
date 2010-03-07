class DashboardsController < ApplicationController
  before_filter :render_home_page
  
  def show
    @participating_quizzes = current_user.participating_quizzes
    @your_quizzes = current_user.quizzes
  end
  
  private
  
  def render_home_page
    unless current_user
      render :template => 'pages/home' and return
    end
  end
end
