class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if verify_recaptcha(:model => @user) && @user.save
      flash[:success] = 'Welcome to Quizdoo!'
      redirect_back_or_default root_url
    else
      render :new
    end
  end
 
  def edit
    @user = @current_user
  end
  
  def update
    @user = @current_user
    if @user.update_attributes(params[:user])
      flash[:success] = 'Account updated'
      redirect_to edit_user_url
    else
      render :edit
    end
  end
end