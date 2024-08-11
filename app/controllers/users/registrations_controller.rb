class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters
  
  def new
    @user = User.new
    super
  end

  def create
    params[:user][:uid] = sign_up_params[:email]
    params[:user][:provider] = :email
    super
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

  def destroy
    ActiveRecord::Base.transaction do
      resource.destroy
      # raise
      if resource.company?
        resource.company.destroy
      end
    end
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message! :notice, :destroyed
    yield resource if block_given?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name), status: Devise.responder.redirect_status }
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