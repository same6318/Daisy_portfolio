class Review < ApplicationRecord
  belongs_to :user
  belongs_to :company

  validates :enrollment_status, inclusion: {in: [true, false]}
  validates :work_life_balance, presence: true
  validates :workplace_atmosphere, presence: true
  validates :flex_system, presence: true
  validates :remote_work, presence: true
  validates :harassment_prevention, presence: true 
  validates :parental_care_leave, presence: true
  validates :childcare_support, presence: true
  validates :welfare_facilities, presence: true
  validates :mental_health_care, presence: true
  validates :evaluation_system, presence: true
  validates :promotion_salary, presence: true
  validates :overtime_holiday_work, presence: true
  validates :allowances_subsidies, presence: true
  validates :training_education_support, presence: true
  validates :career_support, presence: true
  validates :work_engagement, presence: true
  
  validates :content, presence: true, length: { minimum: 100 }

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

  def self.form_attr
    {
    work_life_balance: 'ワークライフバランス',
    workplace_atmosphere: '職場の雰囲気',
    flex_system: 'フレックス制度',
    remote_work: 'リモートワーク',
    harassment_prevention: 'ハラスメント対策',
    parental_care_leave: '育児・介護休暇',
    childcare_support: '育児支援制度',
    welfare_facilities: '福利厚生施設',
    mental_health_care: 'メンタルヘルスケア',
    evaluation_system: '評価制度',
    promotion_salary: '昇進・昇給に関して',
    overtime_holiday_work: '残業、休日出勤',
    allowances_subsidies: '手当・補助等',
    training_education_support: '研修・教育支援',
    career_support: 'キャリアアップ支援',
    work_engagement: '仕事のやりがい'
  }
  end

  # 文字列をひらがなに変換
  def self.to_hiragana(text)
    NKF.nkf('-w --hiragana', text)
  end

  # 文字列をカタカナに変換
  def self.to_katakana(text)
    NKF.nkf('-w --katakana', text)
  end  

  def review_average #レビューの平均値。
    item_values = review_items.values
    (item_values.sum.to_f / review_items.size).round(1)
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[enrollment_status content created_at company_name name age gender] #親クラスのメソッドを呼び出し、追加でレビューに追加したい属性を記載。
    #user_nameやcompany_nameはransackで使用する仮の属性名。カラムが無くても使える。
  end

  ransacker :company_name do
    Arel.sql('COMPANIES.name')  # 仮の属性を設定するためのSQL(アドミンだけでの検索機能)
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user company]
  end

end
