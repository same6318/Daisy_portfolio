class Topic < ApplicationRecord
  belongs_to :user
  belongs_to :company, optional: true

  validates :title, presence: true
  validates :content, presence: true

  has_many_attached :topic_images
  validates :topic_images, presence: false, blob: { content_type: :image }
  
  enum genre: { care: 0, work: 1, life: 2, event: 3, other: 4 }

  # 文字列をひらがなに変換
  def self.to_hiragana(text)
    NKF.nkf('-w --hiragana', text)
  end

  # 文字列をカタカナに変換
  def self.to_katakana(text)
    NKF.nkf('-w --katakana', text)
  end

  ransacker :user_screen_name do
    Arel.sql('USERS.screen_name')  # 仮の属性を設定するためのSQL(アドミンだけでの検索機能)
  end

  def self.ransackable_attributes(auth_object = nil)
    super + %w[title content genre created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    super + %w[user company]
  end

end
