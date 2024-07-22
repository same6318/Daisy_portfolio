class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update]

  def index
    @users = User.all
  end

  def show
  end

  def update
    @user = current_user # 現在のユーザーを取得
  
    if @user.update(user_params)
      flash[:notice] = "アカウントを更新しました"
  
      # 役割に応じてリダイレクト先を変更
      if @user.role == 'admin'
        redirect_to admin_companies_path # 管理者用のページにリダイレクト
      else
        redirect_to companies_path # 一般ユーザー用のページにリダイレクト
      end
    else
      render :edit # 更新に失敗した場合は編集ページを再表示
    end
  end
  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :age, :gender, :email, :screen_name, :password, :password_confirmation, :purpose,:role)
  end

  def correct_user
    @user = User.find(params[:id])
    unless current_user == @user
      flash[:alert] = "アクセス権がありません"
      redirect_to users_path # アクセス権がない場合はリダイレクト
    end
  end
end