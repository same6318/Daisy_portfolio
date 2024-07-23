class CompaniesController < ApplicationController


  def index
    @q = Company.ransack(params[:q])
    @companies = @q.result(distinct: true).left_joins(:reviews) #企業テーブルにレビューテーブルを結合
    .select('companies.*, COUNT(reviews.id) AS reviews_count') #レビューidの数をカウントする
    .group('companies.id') #集計する為にグループ化する
    # .order("#{sort_column} #{sort_direction}")
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


  # private

  # def sort_column
  #   params[:sort] || 'average_rating' # デフォルトのソートカラム
  # end

  # def sort_direction
  #   params[:direction] || 'asc' # デフォルトのソート順
  # end

end