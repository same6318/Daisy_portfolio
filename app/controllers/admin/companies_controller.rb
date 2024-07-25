class Admin::CompaniesController < ApplicationController
  before_action :require_admin

  def index
    @companies = Company.left_joins(:reviews) #企業テーブルにレビューテーブルを結合
    .select('companies.*, COUNT(reviews.id) AS reviews_count') #レビューidの数をカウントする
    .group('companies.id') #集計する為にグループ化する
  end

  def show
    @company = Company.find(params[:id])
    @user = @company.users.find_by(company_id: @company.id) #企業に紐づいている企業ユーザーを表示する
    #@reviews = @company.reviews
    @pickup_reviews = @company.reviews.order(created_at: :desc).limit(3) #新着レビュー3個ピックアップ
  end

  def destroy
    @company = Company.find(params[:id])
    @company.destroy
    redirect_to admin_companies_path
  end

  private

  def require_admin
    unless current_user.admin?
      flash[:notice] = "アクセス権限がありません"
      sign_out(current_user) #ユーザーを強制的にログアウトさせる
      redirect_to new_user_session_path
    end
  end

end
