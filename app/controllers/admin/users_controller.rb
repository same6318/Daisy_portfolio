class Admin::UsersController < ApplicationController
  before_action :require_admin

  def index
    if params[:q].present? && params[:q][:name_or_screen_name_cont].present?
      search_word = params[:q][:name_or_screen_name_cont]
      hiragana_search_word = User.to_hiragana(search_word)
      katakana_search_word = User.to_katakana(search_word)
      @q = User.ransack(m: "or", name_or_screen_name_cont_any: [search_word, hiragana_search_word, katakana_search_word])
    else
      @q = User.ransack(params[:q])
    end

    @users = @q.result(distinct: true).includes(:company).page(params[:page]).per(5)
  end

  def show
    @user = User.find(params[:id])
    @topics = @user.topics.all.page(params[:page]).per(3)
    @reviews = @user.reviews.all.page(params[:reviews_page]).per(3)
  end

      # #ページネーション表示
      # @current_user_reviews = current_user.reviews.page(params[:reviews_page]).per(3)
      # @topics = current_user.topics.page(params[:topics_page]).per(3)
      # @reviews = Review.page(params[:page]).per(3)
  

  def destroy
    @user.destroy
    flash[:notice] = "ユーザーを削除しました"
    redirect_to new_admin_session_path
  end

  private

  def require_admin
    # binding.irb
    unless current_user.admin?
      flash[:notice] = "アクセス権限がありません"
      sign_out(current_user) #ユーザーを強制的にログアウトさせる
      redirect_to new_user_session_path
    end
  end


end
