class DashboardsController < ApplicationController
  def show
    @your_quizzes = current_user.quizzes
  end
end
