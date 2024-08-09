class Topic < ApplicationRecord
  belongs_to :user
  belongs_to :company, optional: true

  validates :title, presence: true
  validates :content, presence: true
  validates :genre, presence: true

  enum genre: { career: 0, parenting: 1, caregiving: 2, learning: 3, relationships: 4, beauty: 5, health: 6, finance: 7, partnership: 8, diversity: 9, other: 10 }

  has_many_attached :topic_images
  FILE_NUMBER_LIMIT = 3 #画像枚数の制限
  validate :validate_number_of_files
  validates :topic_images, presence: false, blob: { content_type: :image }
  validate :images_size

  def images_size
    if topic_images.attached?
      topic_images.blobs.each do |blob|
        if blob.byte_size > 2.megabyte
          errors.add(:topic_images, "は2MB以下のファイルをアップロードしてください")
        end
      end
    end
  end

  def validate_number_of_files
    if topic_images.size > FILE_NUMBER_LIMIT
      errors.add(:topic_images, "は#{FILE_NUMBER_LIMIT}件までです")
    end
  end

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
