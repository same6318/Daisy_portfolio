FactoryBot.define do
  factory :company do
    name { "テスト会社" }
    capital { 1000000 }
    employee { 50 }
    sales { 5000000 }
    description { "テスト会社の説明" }
    address { "テスト住所" }
    industry { 1 }
    company_url { "http://testcompany.com" }
    contact { "contact@testcompany.com" }
  end

  factory :review do
    user { association :user }
    company { association :company }
    work_life_balance { 5 }
    workplace_atmosphere { 4 }
    flex_system { 3 }
    remote_work { 5 }
    harassment_prevention { 4 }
    parental_care_leave { 3 }
    childcare_support { 5 }
    welfare_facilities { 4 }
    mental_health_care { 5 }
    evaluation_system { 4 }
    promotion_salary { 3 }
    overtime_holiday_work { 5 }
    allowances_subsidies { 4 }
    training_education_support { 5 }
    career_support { 4 }
    work_engagement { 5 }
    content { "テストレビューの本文がここに入ります。" * 7 }
  end

  factory :first_review, parent: :review do
    select {true } 
    content { "ファーストレビューの本文がここに入ります。" * 7 }
  end

  factory :second_review, parent: :review do
    select { false }
    content { "セカンドレビューの本文がここに入ります。" * 7 }
  end

  factory :third_review, parent: :review do
    select { true } 
    content { "サードレビューの本文がここに入ります。" * 7 }
  end 
end
