class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters
  
  def new
    @user = User.new
    super
  end

  def create
    super do |resource|
      if resource.persisted? # ユーザーが保存された場合
        flash[:new_user_notice] = "アカウントが作成されました！トピック投稿やレビュー投稿はここから行えます。"
      end
    end
    params[:user][:uid] = sign_up_params[:email]
    params[:user][:provider] = :email
    #binding.irb
    #build_resource(uid: params[:user][:email], provider: :email)
  end

  def update
    if resource.update(update_params)
      flash[:notice] = "アカウントを更新しました"
      bypass_sign_in(@user) #アカウント編集後もログイン状態を保持するメソッド。
      redirect_to user_path(resource)
    else
      render :edit
    end
  end

  def cancel
    super
  end
  

  private

  def sign_up_params
    params.require(:user).permit(
      :name, :uid, :provider, :age, :gender, :email, :screen_name, :password, :password_confirmation, :purpose, :role
    )
  end

  #Devise を使ってユーザーの登録やアカウント情報の更新を行うときに使用
  def configure_permitted_parameters
    devise_parameter_sanitizer
    .permit(:sign_up, keys: [:name, :screen_name, :age, :gender])
    devise_parameter_sanitizer
    .permit(:account_update, keys: [:name, :screen_name, :age, :gender])
  end

  def after_sign_up_path_for(resource)
    if resource.provider == 'google_oauth2'
      edit_user_registration_path 
    end
  end

end