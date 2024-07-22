class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters
 
  def new
    super
  end

  def create
    params[:user][:uid] = sign_up_params[:email]
    params[:user][:provider] = :email
    #binding.irb
    #build_resource(uid: params[:user][:email], provider: :email)
    super
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
    users_path
  end
end