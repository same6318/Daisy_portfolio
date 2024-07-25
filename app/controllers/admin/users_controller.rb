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

  # def index #viewから送られてくるパラメータを元にテーブルからデータを検索する
  #   if params[:q].present? && params[:q][:title_or_content_cont].present?
  #     search_word = params[:q][:title_or_content_cont]
  #     hiragana_search_word = Topic.to_hiragana(search_word)
  #     katakana_search_word = Topic.to_katakana(search_word)
  #     @q = Topic.joins(:user).ransack(m: "or", title_or_content_cont_any: [search_word, hiragana_search_word, katakana_search_word])
  #   else
  #     @q = Topic.joins(:user).ransack(params[:q])
  #   end
    
  #   @topics = @q.result(distinct: true).includes(:user, topic_images_attachments: :blob).all.order(created_at: :asc).page(params[:page]).per(9)
  # end

  def show
    @user = User.find(params[:id])
    @topics = @user.topics.all
    @reviews = @user.reviews.all
  end

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
