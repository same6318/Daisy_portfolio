class Admin::TopicsController < ApplicationController
  before_action :require_admin

  def index
    @q = Topic.joins(:user).ransack(params[:q])
    @topics = @q.result(distinct: true).includes(:user, topic_images_attachments: :blob).order(created_at: :desc).page(params[:page]).per(10)
    #binding.irb
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
      flash[:alert] = "パスワードが違います"
      sign_out(current_user) #ユーザーを強制的にログアウトさせる
      redirect_to new_user_session_path
    end
  end


end
