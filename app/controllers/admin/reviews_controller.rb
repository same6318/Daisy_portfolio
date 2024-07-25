class Admin::ReviewsController < ApplicationController
  before_action :require_admin

  def index
    @reviews = Review.includes(:user).all
  end

  def show
    @review = Review.find(params[:id])
    @user = @review.user
    @company = @review.company
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    redirect_to admin_reviews_path
  end

  private

  def require_admin
    unless current_user.admin?
      flash[:notice] = "アクセス権限がありません"
      sign_out(current_user) #ユーザーを強制的にログアウトさせる
      redirect_to new_user_session_path
    end
  end


end
