class Admin::ReviewsController < ApplicationController
  before_action :require_admin

  def index
    if params[:q].present? && params[:q][:content_cont].present?
      search_word = params[:q][:content_cont]
      hiragana_search_word = Review.to_hiragana(search_word)
      katakana_search_word = Review.to_katakana(search_word)
      @q = Review.joins(:company).ransack(m: "and", content_cont_any: [search_word, hiragana_search_word, katakana_search_word], company_name_cont: params[:q][:company_name_cont])
    else
      @q = Review.joins(:company).ransack(params[:q])
    end
    #distinctを使って並べ替えをするときは、一意であることが前提になる。
    @reviews = @q.result.includes(:user, :company).order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @review = Review.find(params[:id])
    @user = @review.user
    @company = @review.company
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    flash[:alert] = t('.destroyed')
    redirect_to admin_reviews_path
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
