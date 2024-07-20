class Users::RegistrationsController < Devise::RegistrationsController

  def new
    super
  end

  def create
    super
  end

  def update
    super
  end

  private

  def user_params
    params.require(:user).permit( :name, :email, :password, :age)
  end
end