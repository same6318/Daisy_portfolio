class ApplicationController < ActionController::Base

  def after_sign_in_path_for(resource)
    user_path(resource)
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path # サインアウト後にルートページへリダイレクト
  end

  def current_user_role
    current_user.role # 現在のユーザーの役割を取得するメソッド
  end
end
