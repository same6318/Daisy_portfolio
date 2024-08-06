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
  age: rand(0..3),
  gender: rand(0..2),
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

company2 = Company.create!(
  name: '株式会社サンプルテクノロジー',
  capital: 2000000, # 資本金
  employee: 100, # 従業員数
  sales: 100000000, # 売上
  description: 'これは株式会社サンプルテクノロジーの説明です。',
  address: '大阪府大阪市1-2-3',
  industry: 2,
  company_url: 'https://www.sampletech.co.jp',
  contact: 'contact@sampletech.co.jp'
)

company3 = Company.create!(
  name: 'SampleTESTコーポレーション',
  capital: 3000000, # 資本金
  employee: 200, # 従業員数
  sales: 200000000, # 売上
  description: 'これはSampleTESTコーポレーションの説明です。',
  address: '北海道札幌市1-3-5',
  industry: 3,
  company_url: 'https://www.sampletest.co.jp',
  contact: 'contact@sampletest.co.jp'
)

user = User.last #作成したユーザーを代入して、以下のデータ作成時に使用する。

# 5個のレビューを作成
5.times do |i|
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
    content: "これはサンプルレビューの内容です。 #{i + 1} この会社は、働きやすい環境が整っています。社員同士のコミュニケーションも活発で、協力し合いながら業務を進めることができます。福利厚生も充実しており、仕事とプライベートの両立が可能です。特に、リモートワーク制度が整備されており、柔軟な働き方が実現できる点が魅力です。",
    select: [true, false].sample,
    created_at: Time.now - i.days # 日付を1日ずつずらして作成
  )
end

topic = Topic.create!(
    user: user,
    title: "働き方",
    genre: 1,
    content: "仕事とワークライフのバランスは、現代社会においてますます重要になっています。効率的な時間管理と柔軟な働き方が、ストレス軽減と生産性向上に繋がります。あなたの経験をシェアしてください。"
  )
topic.topic_images.attach(io: File.open("public/images/seed_images4.jpg"), filename: "seed_images4.jpg")

topic2 = Topic.create!(
    user: user,
    title: "家族との時間",
    genre: 2,
    content: "時短勤務は、育児や介護などの家庭の事情と仕事を両立するための素晴らしい選択肢です。勤務時間を短縮することで、家族との時間を増やし、仕事の効率を高めることができます。"
  )
topic2.topic_images.attach(io: File.open("public/images/seed_images2.png"), filename: "seed_images2.png")

topic3 = Topic.create!(
    user: user,
    title: "育休のススメ",
    genre: 0,
    content: "育休に対する会社からの援助は、働く親にとって非常に大切です。給付金やサポートプログラムを通じて、育児と仕事を両立しやすい環境が整っています。あなたの会社の支援について教えてください。"
  )
topic3.topic_images.attach(io: File.open("public/images/seed_images1.png"), filename: "seed_images1.png")

admin = User.create!(
  name: '管理者',
  email: 'daisy_admin@example.com',
  role: "admin",
  password: 'admin_password',
  password_confirmation: 'admin_password',
  uid: 'daisy_admin@example.com',
  provider: 'default'
)