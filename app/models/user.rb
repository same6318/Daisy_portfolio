class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, 
         :omniauthable, omniauth_providers: [:google_oauth2]
  has_many :topics, dependent: :destroy
  has_many :reviews, dependent: :destroy
  belongs_to :company, optional: true

  enum age: { teens: 0, twenties: 1, thirties: 2, forties: 3 }
  enum gender: { male: 0, female: 1, other: 2 }
  # purpose: { personal: 0, business: 1, education: 2, hobby: 3 }
  enum role: { general: 0, company: 1, admin: 2 }
  

  #Googleログイン
  def self.create_unique_string
    SecureRandom.uuid
  end

  def self.find_for_google(auth)
    user = User.find_by(email: auth.info.email)
  
    unless user
      user = User.new(email: auth.info.email,
                      provider: auth.provider,
                      uid:      auth.uid,
                      password: Devise.friendly_token[0, 20])
    end
    user.save
    user
  end








  #admin画面でのユーザー検索関連
  def self.ransackable_attributes(auth_object = nil)
    %w[name email screen_name role created_at age gender]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[company topic review]
  end

    # 文字列をひらがなに変換
  def self.to_hiragana(text)
    NKF.nkf('-w --hiragana', text)
  end

  # 文字列をカタカナに変換
  def self.to_katakana(text)
    NKF.nkf('-w --katakana', text)
  end

end
