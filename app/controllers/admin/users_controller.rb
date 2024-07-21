class Admin::UsersController < ApplicationController
  before_action :require_admin

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @topics = @user.topics.all
    @reviews = @user.reviews.all
  end

  def destroy
    @user.destroy
    redirect_to new_admin_session_path
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
