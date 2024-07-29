class Admin::SessionsController < Devise::SessionsController
  before_action :authenticate_user! #ログインユーザーかの確認
  before_action :require_admin, only: [:destroy] #ユーザーのステータスを確認

  def new
    super
  end

  def create
    super do
    #redirect_to admin_users_path これを書くと、デバイスが持っているリダイレクトと重複するのでエラーになる
      flash[:notice] = "ログインしました"
    end
  end

  def destroy
    super do
      flash[:notice] = "ログアウトしました"
    end
  end

  private

  def after_sign_in_path_for(resource)
    admin_users_path
  end

  def after_sign_out_path_for(resource)
    new_admin_session_path
  end

  def require_admin
    unless current_user.admin?
      flash[:notice] = "パスワードが違います"
      sign_out(current_user) #ユーザーを強制的にログアウトさせる
      redirect_to new_user_session_path
    end
  end

end
