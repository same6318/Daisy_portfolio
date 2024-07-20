class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
  end

  def show
  end

  def update
  end

  def destroy
  end
  

  private

  def set_user
    @user = User.find(params[:id])
  end

end