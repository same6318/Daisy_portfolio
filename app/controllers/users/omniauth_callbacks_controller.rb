class Users::OmniauthCallbacksController <  Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.find_for_google(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "google") if is_navigational_format?
      #sign_in @user ,event: :authentication 
      #redirect_to users_path
    else
      session['devise.google_data'] = request.env['omniauth.auth'].except('extra')
      redirect_to new_user_registration_url
    end
  end

  private

  def after_sign_in_path_for(resource)
    #binding.irb
    users_path 
  end

  # def after_sign_in_path_for(resource)
  #   if resource.provider == 'google_oauth2' && resource.first_sign_in
  #     # 初めてサインインした場合は編集ページにリダイレクト
  #     resource.update(first_sign_in: false) # サインイン後にフラグを更新
  #     edit_user_path(@user)
  #   else
  #     super
  #   end
  # end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path # サインアウト後にログインページにリダイレクト
  end
end
