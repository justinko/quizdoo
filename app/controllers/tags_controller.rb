class TagsController < ApplicationController
  before_filter :find_quiz
  
  def show
    @tag = Tag.find(params[:id])
    @questions = @quiz.questions.tagged_with(@tag)
    @tags = @quiz.tags
  end
end