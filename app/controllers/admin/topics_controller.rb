class Admin::TopicsController < ApplicationController
  before_action :require_admin

  def index
    #検索ワードの中に文字が入っていたら、以下のif文に入る。
    if params[:q].present? && params[:q][:title_or_content_cont].present?
      search_word = params[:q][:title_or_content_cont]
      hiragana_search_word = Topic.to_hiragana(search_word)
      katakana_search_word = Topic.to_katakana(search_word)
      @q = Topic.joins(:user).ransack(m: "and", title_or_content_cont_any: [search_word, hiragana_search_word, katakana_search_word], user_screen_name_cont: params[:q][:user_screen_name_cont], user_name_cont: params[:q][:user_name_cont], genre_eq: params[:q][:genre_eq])
      #binding.irb
    else
      @q = Topic.joins(:user).ransack(params[:q])

    end
    @topics = @q.result.includes(:user, topic_images_attachments: :blob).order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @topic = Topic.find(params[:id])
    @user = @topic.user
  end

  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy
    flash[:alert] = t('.destroyed')
    redirect_to admin_topics_path
  end

  private

  def require_admin
    unless current_user.admin?
      flash[:alert] = "パスワードが違います"
      sign_out(current_user) #ユーザーを強制的にログアウトさせる
      redirect_to new_user_session_path
    end
  end


end
