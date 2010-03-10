class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @categories = Category.all(:order => 'name ASC')
  end
end
