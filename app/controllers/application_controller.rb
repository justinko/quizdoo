# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  
  THE_DOMAIN = 'quizdoo.com'
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  filter_parameter_logging :password, :password_confirmation
  
  class AccessDenied < StandardError; end
  
  rescue_from AccessDenied do |exception|
    flash[:failure] = exception.message
    redirect_to root_url
  end
  
  helper_method :current_user_session,
                :current_user,
                :owner?
  
  before_filter :ensure_domain

  private
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def require_user
    unless current_user
      store_location
      flash[:failure] = 'Please login'
      redirect_to login_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:failure] = 'Please logout'
      redirect_to root_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  def owner?
    return false unless current_user
    @quiz.user == current_user
  end
  
  def find_quiz
    @quiz = Quiz.find(params[:quiz_id] || params[:id])
  end
  
  def find_question
    @question = @quiz.questions.find(params[:question_id] || params[:id])
  end
  
  def authorize_quiz
    access_denied! unless current_user.can_edit_quiz?(@quiz)
  end
  
  def authorize_question
    access_denied! unless current_user.can_edit_question?(@question)
  end
  
  def access_denied!(message = 'You do not have access to this page')
    raise AccessDenied, message
  end
  
  def ensure_domain
    if request.env['HTTP_HOST'] != THE_DOMAIN
      redirect_to THE_DOMAIN
    end
  end
end
