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
    item_values.sum.to_f / review_items.size
  end

end
