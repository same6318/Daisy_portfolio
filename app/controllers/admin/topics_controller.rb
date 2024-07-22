class Admin::TopicsController < ApplicationController
  before_action :require_admin

  def index
    @topics = Topic.includes(:user).all
  end

  def show
    @topic = Topic.find(params[:id])
    @user = @topic.user
  end

  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy
    redirect_to admin_topics_path
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