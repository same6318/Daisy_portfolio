class Admin::ReviewsController < ApplicationController
  before_action :require_admin

  def index
    @q = Review.joins(:company).ransack(params[:q])
    #binding.irb
    # @reviews = @q.result(distinct: true).includes(:user, :company).page(params[:page]).per(10)
    @reviews = @q.result.includes(:user, :company).page(params[:page]).per(10)
    #distinctを使って並べ替えをするときは、一意であることが前提になる。

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
      flash[:alert] = "パスワードが違います"
      sign_out(current_user) #ユーザーを強制的にログアウトさせる
      redirect_to new_user_session_path
    end
  end


end
