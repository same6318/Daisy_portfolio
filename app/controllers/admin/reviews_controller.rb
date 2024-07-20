class Admin::ReviewsController < ApplicationController

  def index
    @reviews = Review.includes(:user).all
  end

  def show
    @review = Review.find(params[:id])
    @user = @review.user
    @company = @review.company
  end

  def destroy
    @review.destroy
    redirect_to admin_reviews_path
  end

end
