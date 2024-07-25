class UsersController < ApplicationController
  before_action :authenticate_user! #理由が分からない。, only:[:edit,:update]
  before_action :set_user, only: [:show, :edit, :update]
  before_action :authorize_user, only: [:show]


  def index
    #レビューとトピックス数
    @review_count = current_user.reviews.size
    @topic_count = current_user.topics.size

    #ページネーション表示
    @current_user_reviews = current_user.reviews.page(params[:reviews_page]).per(3)
    @topics = current_user.topics.page(params[:topics_page]).per(3)
    @reviews = Review.page(params[:page]).per(3)
  end

  def show
  end

  def update
    @user = current_user # 現在のユーザーを取得
  
    if @user.update(user_params)
      sign_in :user, @user, bypass: true #更新後、同じパスワードを入力または新パスワード入力してもログイン状態にする
      flash[:notice] = "アカウントを更新しました"
      redirect_to user_path(@user) # 更新後にユーザーの詳細ページにリダイレクト
    else
      render :edit # 更新に失敗した場合は編集ページを再表示
    end
  end


  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user)
    .permit(:name, :age, :gender, :email, :screen_name, :role, :password, :password_confirmation)
  end

  def authorize_user
    unless current_user == @user
      flash[:alert] = 'アクセス権限がありません'
      redirect_to users_path
    end
  end
end