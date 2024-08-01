class CompaniesController < ApplicationController

  def index
    @q = Company.ransack(params[:q])
    @companies = @q.result(distinct: true).left_joins(:reviews) #企業テーブルにレビューテーブルを結合
                        .select('companies.*, COUNT(reviews.id) AS reviews_count') #レビューidの数をカウントする
                        .group('companies.id') #集計する為にグループ化する
                        .page(params[:page]).per(10)
  end


  def show
    @company = Company.find(params[:id])
    @reviews = @company.reviews
    @pickup_reviews = @company.reviews.order(created_at: :desc).limit(3) #新着レビュー3個ピックアップ
  end

  def destroy
    @company.destroy
    redirect_to admin_companies_path
  end


end