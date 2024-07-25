class TopController < ApplicationController
  before_action :redirect_if_logged_in

  def index
    # @selected_reviews = Review.order(Arel.sql('RANDOM()')).limit(3) 
    # @grouped_reviews = @selected_reviews.group_by { |review| review.company }
    # @selected_topics = Topic.order(Arel.sql('RANDOM()')).limit(3)
    # @selected_reviews = Review.order(Arel.sql('RANDOM()')).limit(3) # ランダムで2件取得する

    @selected_reviews = Review.order(created_at: :desc).limit(3)
    # 取得したレビューを企業ごとにグループ化
    @grouped_reviews = @selected_reviews.group_by(&:company)
    
    # 最新のトピックを3件取得する
    @selected_topics = Topic.order(created_at: :desc).limit(3)
    #binding.irb

  end

  private
  def redirect_if_logged_in
    if user_signed_in?
      redirect_to users_path, alert: 'ログアウトしてください'
    end
  end
end
