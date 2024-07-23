# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.create!(
  name: 'デイジー',
  email: 'daisy@example.com',
  password: 'password', # 必要に応じてセキュアなパスワードを設定
  password_confirmation: 'password',
  uid: SecureRandom.uuid,  # ランダムなUIDを設定
  provider: 'default' 
)

# 会社の作成
company = Company.create!(
  name: 'デイジー株式会社',
  capital: 1000000, # 資本金
  employee: 50, # 従業員数
  sales: 50000000, # 売上
  description: 'これはデイジー株式会社の説明です。',
  address: '東京都渋谷区1-1-1',
  industry: 1,
  company_url: 'https://www.daisy.co.jp',
  contact: 'contact@daisy.co.jp'
)

# 30個のレビューを作成
30.times do |i|
  Review.create!(
    user: user,
    company: company,
    work_life_balance: rand(1..5),
    workplace_atmosphere: rand(1..5),
    flex_system: rand(1..5),
    remote_work: rand(1..5),
    harassment_prevention: rand(1..5),
    parental_care_leave: rand(1..5),
    childcare_support: rand(1..5),
    welfare_facilities: rand(1..5),
    mental_health_care: rand(1..5),
    evaluation_system: rand(1..5),
    promotion_salary: rand(1..5),
    overtime_holiday_work: rand(1..5),
    allowances_subsidies: rand(1..5),
    training_education_support: rand(1..5),
    career_support: rand(1..5),
    work_engagement: rand(1..5),
    content: "これはサンプルレビューの内容です #{i + 1}",
    select: [true, false].sample,
    created_at: Time.now - i.days # 日付を1日ずつずらして作成
  )
end