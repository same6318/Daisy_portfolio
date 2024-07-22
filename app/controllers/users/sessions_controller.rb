class Users::SessionsController < Devise::SessionsController
  before_action :authenticate_user! #ログインユーザーかの確認
  before_action :redirect_if_logged_in, only: [:new]
 



  def new
   super
   flash[:notice] = 'ログアウトしてください' if user_signed_in?
  end



  private

  def after_sign_in_path_for(resource)
    users_path # サインイン後に /users にリダイレクト
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path # サインアウト後にログインページにリダイレクト
  end

  def redirect_if_logged_in
    if user_signed_in?
      redirect_to users_path, alert: 'ログアウトしてください'
    end
  end
end
