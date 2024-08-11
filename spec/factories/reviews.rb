FactoryBot.define do
  factory :company do
    name { "テスト会社" }
    capital { 1000000 }
    employee { 50 }
    sales { 5000000 }
    description { "私たちは、製造業において環境への配慮を最優先に考え、持続可能な製品開発を行っています。\n
                  省エネルギー技術とリサイクル資源の活用で、地球に優しい製造プロセスを追求しています。" }
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
    enrollment_status {true } 
    content { "ファーストレビューの本文がここに入ります。" * 7 }
  end

  factory :second_review, parent: :review do
    enrollment_status { false }
    content { "セカンドレビューの本文がここに入ります。" * 7 }
  end

  factory :third_review, parent: :review do
    enrollment_status { true } 
    content { "サードレビューの本文がここに入ります。" * 7 }
  end 

  factory :review5, class: Review do
    work_life_balance { 3 }
    workplace_atmosphere { 4 }
    flex_system { 2 }
    remote_work { 5 }
    harassment_prevention { 3 }
    parental_care_leave { 4 }
    childcare_support { 5 }
    welfare_facilities { 4 }
    mental_health_care { 3 }
    evaluation_system { 2 }
    promotion_salary { 3 }
    overtime_holiday_work { 4 }
    allowances_subsidies { 5 }
    training_education_support { 3 }
    career_support { 4 }
    work_engagement { 5 }
    content { "株式会社サンプル3の福利厚生は非常に充実しています。社員の健康と幸福を第一に考え、各種手当や保険制度が整備されており、安心して働ける環境が提供されています。特に健康診断やフィットネス支援が魅力的です。" }
    enrollment_status { true }
    association :user
    association :company
  end

  factory :review6, class: Review do
    work_life_balance { 3 }
    workplace_atmosphere { 4 }
    flex_system { 2 }
    remote_work { 5 }
    harassment_prevention { 3 }
    parental_care_leave { 4 }
    childcare_support { 5 }
    welfare_facilities { 4 }
    mental_health_care { 3 }
    evaluation_system { 2 }
    promotion_salary { 3 }
    overtime_holiday_work { 1 }
    allowances_subsidies { 1 }
    training_education_support { 1 }
    career_support { 1 }
    work_engagement { 1 }
    content { "株式会社サンプル3の職場環境は非常に良好です。オフィスは清潔で快適、同僚とのコミュニケーションも活発で、働きやすさを感じる職場です。チームワークが重要視され、社員同士のサポート体制も整っています。さらに、定期的な社内イベントも開催され、社員間の連携が強化されています。" }
    enrollment_status { false }
    association :user
    association :company
  end

  factory :review7, class: Review do
    work_life_balance { 3 }
    workplace_atmosphere { 4 }
    flex_system { 2 }
    remote_work { 5 }
    harassment_prevention { 3 }
    parental_care_leave { 4 }
    childcare_support { 5 }
    welfare_facilities { 4 }
    mental_health_care { 3 }
    evaluation_system { 2 }
    promotion_salary { 3 }
    overtime_holiday_work { 4 }
    allowances_subsidies { 2 }
    training_education_support { 2 }
    career_support { 3 }
    work_engagement { 1 }
    content { "株式会社サンプル3の有給休暇取得率は非常に高いです。社員がバランスの取れた生活を送れるように、有給休暇の取得が奨励されており、プライベートの時間も大切にできます。柔軟な休暇制度が整っており、安心して休暇を取ることができます。" }
    enrollment_status { true }
    association :user
    association :company
  end


end
