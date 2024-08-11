class Company < ApplicationRecord
  has_many :users, dependent: :nullify
  has_many :reviews, dependent: :destroy
  has_one_attached :company_image
  validates :company_image, presence: false, blob: { content_type: :image }
  validates :name, presence: true
  validates :capital, presence: true
  validates :employee, presence: true
  validates :sales, presence: true
  validates :description, presence: true, length: { minimum: 100 }
  validates :address, presence: true
  validates :industry, presence: true

  validate :image_size
  enum industry: { manufacturing: 0, service: 1, information_technology: 2, commerce: 3, construction: 4, other: 5}

  def image_size
    if company_image.attached? && company_image.blob.byte_size > 2.megabyte
      errors.add(:company_image, "は2MB以下のファイルをアップロードしてください")
    end
  end

  def formatted_capital #資本金に単位を付けて表示する
    if capital >= 100000000
      (capital / 1_000_000).to_s + "百万円"
    else
      (capital / 10_000).to_s + "万円"
    end
  end

  def formatted_sales #売上高に単位を付けて表示する
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
    %w[name address industry created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    auth_object = []
  end

end
