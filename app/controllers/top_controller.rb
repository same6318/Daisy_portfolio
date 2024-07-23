class TopController < ApplicationController
  before_action :redirect_if_logged_in

  def index
    @selected_reviews = Review.order(Arel.sql('RANDOM()')).limit(2) # ランダムで2件取得する
  end

  private
  def redirect_if_logged_in
    if user_signed_in?
      redirect_to users_path, alert: 'ログアウトしてください'
    end
  end
end
