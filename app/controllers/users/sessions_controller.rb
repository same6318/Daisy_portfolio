class Users::SessionsController < Devise::SessionsController
  before_action :authenticate_user! #ログインユーザーかの確認


  def new
   super
   flash[:alert] = 'ログアウトしてください' if user_signed_in?
  end


  private

  def after_sign_in_path_for(resource)
   #binding.irb
    users_path # サインイン後に /users にリダイレクト
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path # サインアウト後にログインページにリダイレクト
  end
end
