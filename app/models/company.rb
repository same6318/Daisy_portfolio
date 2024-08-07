class Company < ApplicationRecord
  has_many :users
  has_many :reviews, dependent: :destroy

  def formatted_capital #資本金に単位を付けてで表示する
    if capital >= 100000000
      (capital / 1_000_000).to_s + "百万円"
    else
      (capital / 10_000).to_s + "万円"
    end
  end

  def formatted_sales #売上金に単位を付けてで表示する
    if sales >= 100000000
      (sales / 1_000_000).to_s + "百万円"
    else
      (sales / 10_000).to_s + "万円"
    end
  end


  def company_reviews_average
    if reviews.empty?
      return "データはありません"
    else
      total_average = reviews.sum(&:review_average) #企業が持っているレビューの平均値全てを合計する
      (total_average / reviews.count).round(2) #トータルをレビューの数で割る
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[name address created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    auth_object = []
  end

end
