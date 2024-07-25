class Review < ApplicationRecord
  belongs_to :user
  belongs_to :company

  def review_items #レビューの値をハッシュ化する
    {
      work_life_balance: work_life_balance,
      workplace_atmosphere: workplace_atmosphere,
      flex_system: flex_system,
      remote_work: remote_work,
      harassment_prevention: harassment_prevention,
      parental_care_leave: parental_care_leave,
      childcare_support: childcare_support,
      welfare_facilities: welfare_facilities,
      mental_health_care: mental_health_care,
      evaluation_system: evaluation_system,
      promotion_salary: promotion_salary,
      overtime_holiday_work: overtime_holiday_work,
      allowances_subsidies: allowances_subsidies,
      training_education_support: training_education_support,
      career_support: career_support,
      work_engagement: work_engagement
    }
  end

  def review_average #レビューの平均値。
    item_values = review_items.values
    (item_values.sum.to_f / review_items.size).round(1)
  end

  def self.ransackable_attributes(auth_object = nil)
    super + %w[select created_at company_name] #親クラスのメソッドを呼び出し、追加でレビューに追加したい属性を記載。
    #user_nameやcompany_nameはransackで使用する仮の属性名。カラムが無くても使える。
  end

  ransacker :company_name do
    Arel.sql('COMPANIES.name')  # 仮の属性を設定するためのSQL(アドミンだけでの検索機能)
  end

  def self.ransackable_associations(auth_object = nil)
    super + %w[user company]
  end

end
