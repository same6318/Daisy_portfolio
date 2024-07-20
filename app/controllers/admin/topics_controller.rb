class Admin::TopicsController < ApplicationController

  def index
    @topics = Topic.includes(:user).all
  end

  def show
    @topic = Topic.find(params[:id])
    @user = @topic.user
  end

  def destroy
    @topic.destroy
    redirect_to admin_topics_path
  end

end
