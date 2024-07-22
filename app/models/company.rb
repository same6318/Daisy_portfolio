class Company < ApplicationRecord
  has_many :users
  has_many :reviews

  def company_reviews_average
    if reviews.empty?
      return "データはありません"
    else
      total_average = reviews.sum(&:review_average) #企業が持っているレビューの平均値全てを合計する
      total_average / reviews.count #トータルをレビューの数で割る
    end
  end

end
