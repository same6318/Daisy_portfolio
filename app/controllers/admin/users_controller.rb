class Admin::UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @topics = @user.topics.all
    @reviews = @user.reviews.all
  end

end
